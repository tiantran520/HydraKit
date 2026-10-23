import SwiftUI

/// A circular water-level indicator with two moving waves and a localized percentage.
/// Percentage is parent-owned input in 0...100; the component never modifies it.
public struct HKWaterWave: View {
    @Environment(\.ironBitTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.scenePhase) private var scenePhase
    @State private var isMounted = false

    private let level: CGFloat
    private let color: Color?
    private let backgroundColor: Color?
    private let textColor: Color?
    private let showsPercentage: Bool
    private let waveHeight: CGFloat
    private let duration: Double
    private let isAnimating: Bool
    private let accessibilityLabel: Text

    /// - Parameters:
    ///   - percentage: Water height in percent, clamped to 0...100; invalid input becomes zero.
    ///   - color: Water color; nil uses theme primary. The rear wave derives a lighter tint.
    ///   - backgroundColor: Empty area color; nil uses theme surface.
    ///   - textColor: Percentage color; nil uses theme textPrimary. Choose contrast for custom water colors.
    ///   - showsPercentage: Whether to show the centered value, default true.
    ///   - waveHeight: Amplitude as a fraction of diameter, default 0.035, clamped to 0...0.15.
    ///     Automatically tapers near empty/full so waves stay inside the level bounds.
    ///   - duration: Seconds per front-wave cycle, default 2, clamped to 0.25...60;
    ///     invalid input uses 2. The rear wave travels more slowly.
    ///   - isAnimating: Continuous wave motion, default true. Value changes still animate when false.
    ///   - accessibilityLabel: Native progress label, default “Water level”.
    public init(percentage: Double, color: Color? = nil, backgroundColor: Color? = nil,
                textColor: Color? = nil, showsPercentage: Bool = true,
                waveHeight: CGFloat = 0.035, duration: Double = 2, isAnimating: Bool = true,
                accessibilityLabel: Text = Text("Water level")) {
        self.level = HKWaterWaveMetrics.level(for: percentage)
        self.color = color
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.showsPercentage = showsPercentage
        self.waveHeight = waveHeight.isFinite ? min(0.15, max(0, waveHeight)) : 0.035
        self.duration = HKWaterWaveMetrics.duration(duration)
        self.isAnimating = isAnimating
        self.accessibilityLabel = accessibilityLabel
    }

    public var body: some View {
        ZStack {
            Circle().fill(backgroundColor ?? theme.colors.surface)
            TimelineView(.animation(minimumInterval: 1.0 / 30, paused: !animates)) { context in
                let phase = reduceMotion ? 0 : HKWaterWaveMetrics.phase(at: context.date.timeIntervalSinceReferenceDate,
                                                                       duration: duration)
                let rearPhase = reduceMotion ? Double.pi / 2 :
                    HKWaterWaveMetrics.rearPhase(at: context.date.timeIntervalSinceReferenceDate, duration: duration)
                ZStack {
                    HKWaterWaveShape(level: level, phase: rearPhase,
                                     amplitudeRatio: waveHeight * 0.8)
                        .fill((color ?? theme.colors.primary).opacity(0.55))
                    HKWaterWaveShape(level: level, phase: phase, amplitudeRatio: waveHeight)
                        .fill(color ?? theme.colors.primary)
                }
            }
            if showsPercentage {
                Text(Double(level), format: .percent.precision(.fractionLength(0)))
                    .font(theme.typography.display)
                    .monospacedDigit()
                    .foregroundStyle(textColor ?? theme.colors.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                    .padding(theme.spacing.sm)
                    .contentTransition(.numericText(value: Double(level)))
            }
        }
        .clipShape(Circle())
        .aspectRatio(1, contentMode: .fit)
        .animation(reduceMotion ? nil : theme.animations.standard, value: level)
        .accessibilityRepresentation {
            ProgressView(value: Double(level), total: 1) { accessibilityLabel }
                .accessibilityValue(Text(Double(level), format: .percent.precision(.fractionLength(0))))
        }
        .onAppear { isMounted = true }
        .onDisappear { isMounted = false }
    }

    private var animates: Bool {
        isMounted && isAnimating && !reduceMotion && scenePhase == .active &&
            level > 0 && level < 1 && waveHeight > 0
    }
}

#Preview("Water wave: 50 percent, yellow") {
    HKWaterWave(percentage: 50, color: .yellow, textColor: .black)
        .frame(width: 220, height: 220)
        .padding(24)
}

#Preview("Water wave: interactive level and colors") {
    HKWaterWavePreview().padding()
}

#Preview("Water wave: light, dark, text sizes and endpoints") {
    HKComponentPreview {
        HStack {
            HKWaterWave(percentage: 0)
            HKWaterWave(percentage: 80, color: .blue, textColor: .black)
            HKWaterWave(percentage: 100, color: .teal)
        }
        HKWaterWave(percentage: 65, color: .blue, isAnimating: false)
            .frame(width: 160, height: 160)
    }
}
