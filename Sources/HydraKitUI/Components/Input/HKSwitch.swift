import SwiftUI

/// A pill switch with parent-owned selection and native Toggle accessibility semantics.
/// This is independent of HKToggle; it never changes the app theme itself.
public struct HKSwitch: View {
    /// Placement of the active state's content.
    public enum HKVariant: Sendable {
        /// Symbol on the track, opposite an empty circular thumb.
        case trackIcon
        /// Symbol inside the circular thumb, with an empty track.
        case thumbIcon
        /// State title on the track and symbol inside the thumb.
        case labeled
    }

    /// Metrics derived from the theme. Symbols scale within the thumb; labels wrap with Dynamic Type.
    public enum HKSize: Sendable { case sm, md, lg }

    /// Optional state-specific content and track colors. Nil colors use semantic theme tokens.
    public struct StateAppearance {
        /// Visual title for the labeled variant; nil uses localized On/Off text.
        public let title: Text?
        /// Decorative SF Symbol; nil leaves the symbol area empty.
        public let systemImage: String?
        /// Track background; nil uses primary when on and border when off.
        public let background: Color?
        /// Track foreground; nil uses onPrimary when on and textPrimary when off.
        public let foreground: Color?

        /// Creates state content. All overrides default to nil.
        public init(title: Text? = nil, systemImage: String? = nil,
                    background: Color? = nil, foreground: Color? = nil) {
            self.title = title
            self.systemImage = systemImage
            self.background = background
            self.foreground = foreground
        }
    }

    @Environment(\.ironBitTheme) private var theme
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @ScaledMetric(relativeTo: .body) private var scale: CGFloat = 1
    @FocusState private var isFocused: Bool
    @Binding private var isOn: Bool
    private let title: Text
    private let variant: HKVariant
    private let size: HKSize
    private let on: StateAppearance
    private let off: StateAppearance
    private let thumbColor: Color?
    private let thumbForeground: Color?

    /// Creates a switch. Defaults: medium trackIcon, checkmark/xmark, theme colors.
    /// `title` is the stable accessibility name, separate from visual state titles.
    /// Use `.disabled` for enabled state and `.onChange(of:)` for side effects owned by the parent.
    public init(
        _ title: String, isOn: Binding<Bool>, variant: HKVariant = .trackIcon, size: HKSize = .md,
        on: StateAppearance = StateAppearance(systemImage: "checkmark"),
        off: StateAppearance = StateAppearance(systemImage: "xmark"),
        thumbColor: Color? = nil, thumbForeground: Color? = nil
    ) {
        self.init(Text(title), isOn: isOn, variant: variant, size: size,
                  on: on, off: off, thumbColor: thumbColor, thumbForeground: thumbForeground)
    }

    /// Creates a switch with a localized accessibility title. Nil thumb colors use surface/textPrimary.
    public init(
        _ title: Text, isOn: Binding<Bool>, variant: HKVariant = .trackIcon, size: HKSize = .md,
        on: StateAppearance = StateAppearance(systemImage: "checkmark"),
        off: StateAppearance = StateAppearance(systemImage: "xmark"),
        thumbColor: Color? = nil, thumbForeground: Color? = nil
    ) {
        self.title = title
        self._isOn = isOn
        self.variant = variant
        self.size = size
        self.on = on
        self.off = off
        self.thumbColor = thumbColor
        self.thumbForeground = thumbForeground
    }

    public var body: some View {
        Button { performToggle(isEnabled: isEnabled) } label: {
            track
        }
        .buttonStyle(HKSwitchButtonStyle())
        .focused($isFocused)
        .opacity(isEnabled ? 1 : theme.controls.disabledOpacity)
        .animation(reduceMotion ? nil : theme.animations.standard, value: isOn)
        .accessibilityRepresentation {
            Toggle(isOn: $isOn) { title }
                .toggleStyle(.automatic)
        }
    }

    @MainActor
    func performToggle(isEnabled: Bool) {
        guard isEnabled else { return }
        isOn.toggle()
    }

    private var track: some View {
        HStack(spacing: theme.spacing.sm) {
            if !isOn { thumbSpace }
            trackContent
            if isOn { thumbSpace }
        }
        .padding(inset)
        .frame(minWidth: height * 2, minHeight: height)
        .background(appearance.background ?? (isOn ? theme.colors.primary : theme.colors.border))
        .clipShape(trackShape)
        .overlay(alignment: isOn ? .trailing : .leading) {
            thumb.padding(inset)
        }
        .overlay {
            trackShape.strokeBorder(isFocused ? theme.colors.primary : theme.colors.border,
                                   lineWidth: isFocused ? theme.controls.focusBorderWidth : theme.controls.borderWidth)
        }
        .contentShape(trackShape)
    }

    @ViewBuilder private var trackContent: some View {
        if variant == .labeled {
            (appearance.title ?? (isOn ? Text("On") : Text("Off")))
                .font(theme.typography.caption.weight(.semibold))
                .foregroundStyle(appearance.foreground ?? (isOn ? theme.colors.onPrimary : theme.colors.textPrimary))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, theme.spacing.sm)
                .padding(.vertical, theme.spacing.xs)
                .frame(minWidth: thumbSize, minHeight: thumbSize)
                .accessibilityHidden(true)
        } else if variant == .trackIcon {
            symbol
                .foregroundStyle(appearance.foreground ?? (isOn ? theme.colors.onPrimary : theme.colors.textPrimary))
                .frame(width: thumbSize, height: thumbSize)
        } else {
            thumbSpace
        }
    }

    private var thumb: some View {
        Circle().fill(thumbColor ?? theme.colors.surface)
            .overlay {
                if variant != .trackIcon {
                    symbol.foregroundStyle(thumbForeground ?? theme.colors.textPrimary)
                }
            }
            .frame(width: thumbSize, height: thumbSize)
            .shadow(color: theme.shadows.sm.color, radius: theme.shadows.sm.radius,
                    x: theme.shadows.sm.x, y: theme.shadows.sm.y)
            .accessibilityHidden(true)
    }

    @ViewBuilder private var symbol: some View {
        if let systemImage = appearance.systemImage {
            Image(systemName: systemImage)
                .resizable()
                .scaledToFit()
                .frame(width: symbolSize, height: symbolSize)
                .accessibilityHidden(true)
        }
    }

    private var thumbSpace: some View {
        Color.clear.frame(width: thumbSize, height: thumbSize).accessibilityHidden(true)
    }

    // Keep the target usable at small text sizes; let text wrap and grow vertically at large sizes.
    private var trackShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: height / 2, style: .continuous)
    }

    private var symbolSize: CGFloat {
        let points: CGFloat
        switch size {
        case .sm: points = theme.controls.smallIcon
        case .md: points = theme.controls.mediumIcon
        case .lg: points = theme.controls.largeIcon
        }
        return min(points * scale, max(0, thumbSize - inset * 2))
    }

    private var appearance: StateAppearance { isOn ? on : off }
    private var inset: CGFloat { min(theme.spacing.xs, height / 4) }
    private var thumbSize: CGFloat { max(0, height - inset * 2) }
    private var height: CGFloat {
        let requested: CGFloat
        switch size {
        case .sm: requested = theme.controls.smallHeight
        case .md: requested = theme.controls.mediumHeight
        case .lg: requested = theme.controls.largeHeight
        }
        return max(theme.controls.minimumTarget, requested)
    }
}

private struct HKSwitchButtonStyle: ButtonStyle {
    @Environment(\.ironBitTheme) private var theme

    func makeBody(configuration: Configuration) -> some View {
        configuration.label.opacity(configuration.isPressed ? theme.controls.pressedOpacity : 1)
    }
}

#Preview("Switch variants, states and long labels") {
    @Previewable @State var isDay = true
    HKComponentPreview {
        HKSwitch("Enabled", isOn: $isDay)
        HKSwitch("Thumb symbol", isOn: $isDay, variant: .thumbIcon)
        HKSwitch("Appearance", isOn: $isDay, variant: .labeled, size: .lg,
                 on: .init(title: Text("DAY MODE"), systemImage: "sun.max", background: .yellow, foreground: .black),
                 off: .init(title: Text("NIGHT MODE"), systemImage: "moon.fill", background: .indigo, foreground: .white),
                 thumbColor: .white, thumbForeground: .black)
        HKSwitch("Off", isOn: .constant(false))
        HKSwitch("Disabled", isOn: .constant(true)).disabled(true)
        HKSwitch("Localized setting", isOn: .constant(true), variant: .labeled,
                 on: .init(title: Text("A long localized state title that wraps"), systemImage: "checkmark"))
    }
}
