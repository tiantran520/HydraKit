import SwiftUI

/// Home-style bank card arrangements. Right opens the fan; left closes it;
/// down expands the stack and up collapses it. Directions are physical, as in Facepay Home.
public enum HKBankCardStackPresentation: Sendable {
    case collapsed, fanned, expanded
}

/// A content-driven bank card stack inspired by Facepay Home's WECardsView.
/// The caller supplies display-only card content and owns banking/navigation/deletion logic.
public struct HKBankCardStack<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    @Environment(\.ironBitTheme) private var theme
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.layoutDirection) private var layoutDirection
    @State private var localPresentation: HKBankCardStackPresentation = .collapsed
    @State private var localSelection: Data.Element.ID?
    @State private var revealedID: Data.Element.ID?

    private let items: Data
    private let presentation: Binding<HKBankCardStackPresentation>?
    private let selection: Binding<Data.Element.ID?>?
    private let cardHeight: CGFloat
    private let spacing: CGFloat?
    private let cornerRadius: CGFloat?
    private let onSelect: ((Data.Element) -> Void)?
    private let onDelete: ((Data.Element) -> Void)?
    private let content: (Data.Element) -> Content

    /// - Parameters:
    ///   - items: Front-to-back data with unique stable IDs. Empty data collapses to zero height.
    ///   - presentation: Parent-owned arrangement, or internal collapsed state when omitted.
    ///   - selection: Focused card ID, or internal focus when omitted. Set nil to return to the stack.
    ///   - cardHeight: Unscaled card height. Choose a height suitable for your content/Dynamic Type.
    ///   - spacing: Collapsed peek spacing; nil uses theme spacing.md.
    ///   - cornerRadius: Nil uses theme radius.lg.
    ///   - onSelect: Called after a card is focused. Never performs banking/navigation itself.
    ///   - onDelete: Optional request callback. In expanded mode, swipe a card left to reveal
    ///     its delete button. The component never removes data or confirms deletion itself.
    ///   - content: Display-only content; the component provides the native Button interaction.
    public init(_ items: Data, presentation: Binding<HKBankCardStackPresentation>? = nil,
                selection: Binding<Data.Element.ID?>? = nil, cardHeight: CGFloat,
                spacing: CGFloat? = nil, cornerRadius: CGFloat? = nil,
                onSelect: ((Data.Element) -> Void)? = nil, onDelete: ((Data.Element) -> Void)? = nil,
                @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.items = items
        self.presentation = presentation
        self.selection = selection
        self.cardHeight = cardHeight.isFinite ? max(0, cardHeight) : 0
        self.spacing = spacing
        self.cornerRadius = cornerRadius
        self.onSelect = onSelect
        self.onDelete = onDelete
        self.content = content
    }

    public var body: some View {
        let rows = Array(items)
        let selectedIndex = rows.firstIndex { $0.id == selected.wrappedValue }
        let mode = arrangement.wrappedValue
        let gap = sanitized(spacing ?? theme.spacing.md)
        HKBankCardStackSizing(cardHeight: cardHeight, count: rows.count, mode: mode,
                              gap: gap, inset: theme.spacing.lg, selectedIndex: selectedIndex) {
            GeometryReader { viewport in
                let geometry = HKBankCardStackGeometry(width: viewport.size.width, cardHeight: cardHeight,
                                                      count: rows.count, presentation: mode, spacing: gap,
                                                      inset: theme.spacing.lg, selectedIndex: selectedIndex)
                ZStack(alignment: .topLeading) {
                    ForEach(Array(rows.enumerated()), id: \.element.id) { index, item in
                        if selectedIndex == nil || selectedIndex == index {
                            card(item, index: index, geometry: geometry).transition(.opacity)
                        }
                    }
                }
                .frame(width: geometry.cardWidth, height: cardHeight, alignment: .topLeading)
                .scaleEffect(geometry.fitScale, anchor: .topLeading)
                .offset(x: geometry.origin.x, y: geometry.origin.y)
                .frame(width: viewport.size.width, height: geometry.height, alignment: .topLeading)
                .contentShape(Rectangle())
                .highPriorityGesture(DragGesture(minimumDistance: 12).onEnded { value in
                    guard let swipe = HKBankCardStackSwipe.resolve(translation: value.translation,
                                                                 predicted: value.predictedEndTranslation,
                                                                 threshold: theme.controls.minimumTarget) else { return }
                    let index = geometry.hitTest(value.startLocation)
                    handle(swipe, item: index.map { rows[$0] })
                })
            }
            .environment(\.layoutDirection, .leftToRight)
        }
        .animation(reduceMotion ? nil : theme.animations.standard, value: mode)
        .animation(reduceMotion ? nil : theme.animations.standard, value: selected.wrappedValue)
        .animation(reduceMotion ? nil : theme.animations.standard, value: revealedID)
        .opacity(isEnabled ? 1 : theme.controls.disabledOpacity)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(Text("Bank cards"))
        .accessibilityValue(accessibilityValue)
        .accessibilityHidden(rows.isEmpty || cardHeight == 0)
        .accessibilityAction(named: Text("Expand cards")) { changePresentation(.expanded) }
        .accessibilityAction(named: Text("Collapse cards")) { changePresentation(.collapsed) }
        .accessibilityAction(named: Text("Open card fan")) { changePresentation(.fanned) }
        .accessibilityAction(named: Text("Show all cards")) { if isEnabled { selected.wrappedValue = nil } }
        .onAppear { reconcile() }
        .onChange(of: rows.map(\.id)) { _, _ in reconcile() }
        .onChange(of: selected.wrappedValue) { _, _ in revealedID = nil; reconcile() }
        .onChange(of: mode) { _, _ in revealedID = nil }
    }

    private func card(_ item: Data.Element, index: Int, geometry: HKBankCardStackGeometry) -> some View {
        let pose = geometry.poses[index]
        let focused = selected.wrappedValue
        let hidden = focused != nil && focused != item.id
        let hideAccessibility = hidden || (focused == nil &&
            (arrangement.wrappedValue == .fanned || arrangement.wrappedValue == .collapsed && index > 0))
        let revealed = revealedID == item.id && arrangement.wrappedValue == .expanded && focused == nil
        // Actions retain the theme's minimum target after the depth/viewport transforms.
        let actionScale = max(0.01, pose.scale * geometry.fitScale)
        let actionWidth = max(theme.controls.largeHeight, theme.controls.minimumTarget) / actionScale
        let actionHeight = theme.controls.minimumTarget / actionScale
        let exposedCenter = index == 0 ? cardHeight / 2 :
            min(cardHeight / 2, (cardHeight * 0.5 + sanitized(spacing ?? theme.spacing.md) * 0.5) / (2 * pose.scale))
        return ZStack {
            if revealed, onDelete != nil {
                GeometryReader { area in
                    Button(role: .destructive) {
                        requestDeletion(item)
                    } label: {
                        Image(systemName: "trash")
                            .frame(width: actionWidth, height: actionHeight)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(Text("Remove card"))
                    .position(x: area.size.width - actionWidth / 2, y: exposedCenter)
                }
            }
            Button { select(item) } label: {
                content(item).environment(\.layoutDirection, layoutDirection)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(theme.colors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: sanitized(cornerRadius ?? theme.radius.lg)))
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .offset(x: revealed ? -actionWidth : 0)
            .accessibilityHidden(hideAccessibility)
            .accessibilityActions {
                if onDelete != nil, arrangement.wrappedValue == .expanded, focused == nil {
                    Button(role: .destructive) { requestDeletion(item) } label: { Text("Remove card") }
                }
            }
            .contextMenu {
                if onDelete != nil, arrangement.wrappedValue == .expanded, focused == nil {
                    Button(role: .destructive) { requestDeletion(item) } label: { Label("Remove card", systemImage: "trash") }
                }
            }
        }
        .frame(width: geometry.cardWidth, height: cardHeight)
        .shadow(color: theme.shadows.sm.color, radius: theme.shadows.sm.radius,
                x: theme.shadows.sm.x, y: theme.shadows.sm.y)
        .scaleEffect(pose.scale, anchor: geometry.fanAnchor ? .topTrailing : .top)
        .rotationEffect(.degrees(pose.angle), anchor: geometry.fanAnchor ? .topTrailing : .top)
        .offset(x: pose.x, y: pose.y)
        .zIndex(Double(items.count - index))
        .opacity(hidden ? 0 : 1)
        .allowsHitTesting(!hidden && (arrangement.wrappedValue != .fanned || focused != nil))
        .accessibilityHidden(hideAccessibility)
    }

    private var arrangement: Binding<HKBankCardStackPresentation> { presentation ?? $localPresentation }
    private var selected: Binding<Data.Element.ID?> { selection ?? $localSelection }
    private func sanitized(_ value: CGFloat) -> CGFloat { value.isFinite ? max(0, value) : 0 }
    private var accessibilityValue: Text {
        if selected.wrappedValue != nil { return Text("Card selected") }
        switch arrangement.wrappedValue {
        case .collapsed: return Text("Cards stacked")
        case .fanned: return Text("Card fan open")
        case .expanded: return Text("Cards expanded")
        }
    }

    @MainActor
    func changePresentation(_ value: HKBankCardStackPresentation) {
        guard isEnabled, !items.isEmpty, selected.wrappedValue == nil else { return }
        revealedID = nil
        arrangement.wrappedValue = value
    }

    @MainActor
    func handle(_ swipe: HKBankCardStackSwipe, item: Data.Element?) {
        guard isEnabled, !items.isEmpty, selected.wrappedValue == nil else { return }
        if arrangement.wrappedValue == .expanded, onDelete != nil {
            if swipe == .left, let item { revealedID = item.id; return }
            if swipe == .right, revealedID != nil { revealedID = nil; return }
        }
        changePresentation(HKBankCardStackRules.next(swipe, from: arrangement.wrappedValue))
    }

    @MainActor
    func select(_ item: Data.Element) {
        guard isEnabled, items.contains(where: { $0.id == item.id }) else { return }
        revealedID = nil
        if selected.wrappedValue == item.id { selected.wrappedValue = nil; return }
        guard selected.wrappedValue == nil, arrangement.wrappedValue != .fanned else { return }
        selected.wrappedValue = item.id
        onSelect?(item)
    }

    @MainActor
    func requestDeletion(_ item: Data.Element) {
        guard isEnabled, arrangement.wrappedValue == .expanded, selected.wrappedValue == nil,
              items.contains(where: { $0.id == item.id }) else { return }
        revealedID = nil
        onDelete?(item)
    }

    @MainActor
    func reconcile() {
        if let id = selected.wrappedValue, !items.contains(where: { $0.id == id }) { selected.wrappedValue = nil }
        if let id = revealedID, !items.contains(where: { $0.id == id }) { revealedID = nil }
    }
}

/// Gives GeometryReader the actual transformed stack height without per-frame layout State.
private struct HKBankCardStackSizing: Layout {
    let cardHeight: CGFloat
    let count: Int
    let mode: HKBankCardStackPresentation
    let gap: CGFloat
    let inset: CGFloat
    let selectedIndex: Int?

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width.flatMap { $0.isFinite ? max(0, $0) : nil } ?? 320
        let geometry = HKBankCardStackGeometry(width: width, cardHeight: cardHeight, count: count,
                                              presentation: mode, spacing: gap, inset: inset, selectedIndex: selectedIndex)
        return CGSize(width: width, height: geometry.height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        subviews.first?.place(at: bounds.origin, anchor: .topLeading, proposal: ProposedViewSize(bounds.size))
    }
}

#Preview("Bank cards: interactive swipe demo") {
    HKBankCardStackPreview()
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
}

#Preview("Bank cards: fan, light and dark") {
    HKComponentPreview { HKBankCardStackPreview(mode: .fanned) }
}

#Preview("Bank cards: expanded, light and dark") {
    HKComponentPreview { HKBankCardStackPreview(mode: .expanded) }
}
