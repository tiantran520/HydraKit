import SwiftUI

/// Horizontal, center-snapping cards with a parallax background and stationary overlay.
/// A scroll gesture settles on the current card or one adjacent card, without skipping cards.
/// Items need unique, stable IDs. Content and selection remain owned by the caller.
public struct HKParallaxCarousel<Data: RandomAccessCollection, Background: View, Overlay: View>: View
where Data.Element: Identifiable {
    @Environment(\.ironBitTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var localSelection: Data.Element.ID?
    @State private var scrollRevision: UInt = 0
    private let items: Data
    private let selection: Binding<Data.Element.ID?>?
    private let cardHeight: CGFloat
    private let cardWidthRatio: CGFloat
    private let parallaxStrength: CGFloat
    private let spacing: CGFloat?
    private let cornerRadius: CGFloat?
    private let showsIndicators: Bool
    private let backgroundContent: (Data.Element) -> Background
    private let overlayContent: (Data.Element) -> Overlay

    /// Creates a carousel. Height is explicit; width adapts to the available viewport.
    /// - Parameters:
    ///   - items: Ordered items with unique, stable IDs. Empty collections collapse the carousel.
    ///   - selection: Optional parent-owned scroll position; omitted selection is managed internally.
    ///   - cardHeight: Card height in points. Nonfinite/negative values become zero.
    ///   - cardWidthRatio: Fraction of viewport width, default 0.85. Values above one are clamped;
    ///     nonpositive/nonfinite values use the default.
    ///   - parallaxStrength: Relative image travel, default 0.2, clamped to 0...1.
    ///     Zero or Reduce Motion disables both movement and extra background crop.
    ///   - spacing: Gap between cards; nil uses theme spacing.md.
    ///   - cornerRadius: Card corner radius; nil uses theme radius.lg.
    ///   - showsIndicators: Whether native scroll indicators are shown, default false.
    ///   - background: Media that fills each card; render/rescale images in this closure.
    ///   - overlay: Foreground content, aligned bottom-leading. Buttons keep native interactions.
    public init(
        _ items: Data, selection: Binding<Data.Element.ID?>? = nil, cardHeight: CGFloat,
        cardWidthRatio: CGFloat = 0.85, parallaxStrength: CGFloat = 0.2,
        spacing: CGFloat? = nil, cornerRadius: CGFloat? = nil, showsIndicators: Bool = false,
        @ViewBuilder background: @escaping (Data.Element) -> Background,
        @ViewBuilder overlay: @escaping (Data.Element) -> Overlay
    ) {
        self.items = items
        self.selection = selection
        self.cardHeight = cardHeight.isFinite ? max(0, cardHeight) : 0
        self.cardWidthRatio = cardWidthRatio
        self.parallaxStrength = parallaxStrength
        self.spacing = spacing
        self.cornerRadius = cornerRadius
        self.showsIndicators = showsIndicators
        self.backgroundContent = background
        self.overlayContent = overlay
    }

    public var body: some View {
        Group {
            if !items.isEmpty {
                GeometryReader { viewport in
                    let revision = scrollRevision
                    let expectedSelection = scrollPosition.wrappedValue
                    let geometry = HKParallaxGeometry(viewportWidth: viewport.size.width,
                                                     widthRatio: cardWidthRatio, strength: parallaxStrength,
                                                     reduceMotion: reduceMotion)
                    ScrollViewReader { reader in
                        ScrollView(.horizontal, showsIndicators: showsIndicators) {
                            LazyHStack(spacing: nonnegative(spacing ?? theme.spacing.md)) {
                                ForEach(items) { item in
                                    card(item, geometry: geometry)
                                        .id(item.id)
                                }
                            }
                            .scrollTargetLayout()
                        }
                        .contentMargins(.horizontal, geometry.sideInset, for: .scrollContent)
                        .scrollTargetBehavior(HKCarouselScrollBehavior(
                            cardWidth: geometry.cardWidth,
                            spacing: nonnegative(spacing ?? theme.spacing.md), itemCount: items.count,
                            onTarget: { index in
                                guard scrollRevision == revision,
                                      scrollPosition.wrappedValue == expectedSelection else { return }
                                let ids = itemIDs
                                guard ids.indices.contains(index) else { return }
                                let id = ids[index]
                                if scrollPosition.wrappedValue != id { scrollPosition.wrappedValue = id }
                            }))
                        .scrollPosition(id: commandedPosition, anchor: .center)
                        .transaction { transaction in
                            if reduceMotion { transaction.animation = nil }
                        }
                        .onAppear {
                            // Initial non-first IDs need an explicit scroll once target views exist.
                            if let id = scrollPosition.wrappedValue { reader.scrollTo(id, anchor: .center) }
                        }
                        .onChange(of: itemIDs) { _, _ in
                            // Native scrollPosition can retain the old offset after IDs reorder.
                            reconcileSelection()
                            if let id = scrollPosition.wrappedValue { reader.scrollTo(id, anchor: .center) }
                        }
                        .onChange(of: viewport.size.width) { _, _ in
                            scrollRevision &+= 1
                            // A resize changes the stride; retain the selected card rather than the old offset.
                            if let id = scrollPosition.wrappedValue { reader.scrollTo(id, anchor: .center) }
                        }
                    }
                }
                .frame(height: cardHeight)
            } else {
                // A zero-height node still receives lifecycle updates to clear a stale selection.
                Color.clear.frame(height: 0).accessibilityHidden(true)
            }
        }
        .onAppear { scrollRevision &+= 1; reconcileSelection() }
        .onDisappear { scrollRevision &+= 1 }
        .onChange(of: itemIDs) { _, _ in scrollRevision &+= 1; reconcileSelection() }
        .onChange(of: scrollPosition.wrappedValue) { _, newID in
            scrollRevision &+= 1
            if let newID, !itemIDs.contains(newID) { reconcileSelection() }
        }
    }

    private func card(_ item: Data.Element, geometry: HKParallaxGeometry) -> some View {
        backgroundContent(item)
            .frame(width: geometry.backgroundWidth, height: cardHeight)
            .clipped()
            .visualEffect { effect, proxy in
                effect.offset(x: geometry.offset(cardMidX: proxy.frame(in: .scrollView(axis: .horizontal)).midX))
            }
            .frame(width: geometry.cardWidth, height: cardHeight)
            .clipped()
            .allowsHitTesting(false)
            .overlay(alignment: .bottomLeading) { overlayContent(item) }
            .clipShape(RoundedRectangle(cornerRadius: nonnegative(cornerRadius ?? theme.radius.lg), style: .continuous))
            .accessibilityElement(children: .contain)
    }

    private var itemIDs: [Data.Element.ID] { items.map(\.id) }
    private var scrollPosition: Binding<Data.Element.ID?> { selection ?? $localSelection }
    // Native tracking can choose a neighboring fully visible item for narrow cards.
    // Publish the resolved snap target instead; keep parent-owned navigation writable.
    private var commandedPosition: Binding<Data.Element.ID?> {
        Binding(get: { scrollPosition.wrappedValue }, set: { _ in })
    }

    /// Restore a valid position without duplicating parent-owned state or writing unchanged values.
    @MainActor
    func reconcileSelection() {
        let ids = itemIDs
        let current = scrollPosition.wrappedValue
        let resolved = current.flatMap { ids.contains($0) ? $0 : nil } ?? ids.first
        if current != resolved { scrollPosition.wrappedValue = resolved }
    }

    private func nonnegative(_ value: CGFloat) -> CGFloat { value.isFinite ? max(0, value) : 0 }
}

/// Scroll-target coordinates follow item order; SwiftUI mirrors their display in RTL.
struct HKCarouselScrollBehavior: ScrollTargetBehavior {
    let cardWidth: CGFloat
    let spacing: CGFloat
    let itemCount: Int
    var onTarget: (Int) -> Void = { _ in }

    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        guard cardWidth > 0, itemCount > 0 else { return }
        let originalCenter = context.originalTarget.rect.midX
        let proposedCenter = target.rect.midX
        let center = destination(originalCenter: originalCenter, proposedCenter: proposedCenter)
        target.rect.origin.x = center - cardWidth / 2
        target.rect.size.width = cardWidth
        target.anchor = .center
        // Initial layout, resizing and parent-issued navigation also call updateTarget.
        // Only publish a gesture's resolved card, not those layout adjustments.
        if context.velocity.dx != 0 || abs(originalCenter - proposedCenter) > 0.5 {
            let index = Int(((center - cardWidth / 2) / (cardWidth + spacing)).rounded())
            let publish = onTarget
            Task { @MainActor in publish(index) }
        }
    }

    func destination(originalCenter: CGFloat, proposedCenter: CGFloat) -> CGFloat {
        let stride = cardWidth + spacing
        guard cardWidth > 0, stride.isFinite, stride > 0, itemCount > 0,
              originalCenter.isFinite, proposedCenter.isFinite else { return originalCenter }
        let lastIndex = CGFloat(itemCount - 1)
        let start = min(lastIndex, max(0, ((originalCenter - cardWidth / 2) / stride).rounded()))
        let proposed = ((proposedCenter - cardWidth / 2) / stride).rounded()
        let index = min(lastIndex, max(0, min(start + 1, max(start - 1, proposed))))
        return cardWidth / 2 + index * stride
    }
}

public extension HKParallaxCarousel where Overlay == EmptyView {
    /// Creates an image/background-only carousel with the same defaults as the overlay initializer.
    init(
        _ items: Data, selection: Binding<Data.Element.ID?>? = nil, cardHeight: CGFloat,
        cardWidthRatio: CGFloat = 0.85, parallaxStrength: CGFloat = 0.2,
        spacing: CGFloat? = nil, cornerRadius: CGFloat? = nil, showsIndicators: Bool = false,
        @ViewBuilder background: @escaping (Data.Element) -> Background
    ) {
        self.init(items, selection: selection, cardHeight: cardHeight, cardWidthRatio: cardWidthRatio,
                  parallaxStrength: parallaxStrength, spacing: spacing, cornerRadius: cornerRadius,
                  showsIndicators: showsIndicators, background: background, overlay: { _ in EmptyView() })
    }
}

/// Pure geometry used by the render effect, with enough overscan to prevent revealed image edges.
struct HKParallaxGeometry: Sendable {
    let viewportWidth: CGFloat
    let cardWidth: CGFloat
    let backgroundWidth: CGFloat
    let sideInset: CGFloat
    private let strength: CGFloat
    private let maximumOffset: CGFloat

    init(viewportWidth: CGFloat, widthRatio: CGFloat, strength: CGFloat, reduceMotion: Bool) {
        self.viewportWidth = viewportWidth.isFinite ? max(0, viewportWidth) : 0
        let ratio = widthRatio.isFinite && widthRatio > 0 ? min(1, widthRatio) : 0.85
        self.strength = reduceMotion || !strength.isFinite ? 0 : min(1, max(0, strength))
        self.cardWidth = self.viewportWidth * ratio
        self.maximumOffset = self.cardWidth * self.strength
        self.backgroundWidth = self.cardWidth + self.maximumOffset * 2
        self.sideInset = (self.viewportWidth - self.cardWidth) / 2
    }

    func offset(cardMidX: CGFloat) -> CGFloat {
        guard cardMidX.isFinite, viewportWidth > 0 else { return 0 }
        let offset = (viewportWidth / 2 - cardMidX) * strength
        return min(maximumOffset, max(-maximumOffset, offset))
    }
}

private struct HKCarouselPreviewItem: Identifiable {
    let id: Int
    let title: String
    let symbol: String
    let color: Color

    static let samples = [
        Self(id: 1, title: "Mountains", symbol: "mountain.2.fill", color: .indigo),
        Self(id: 2, title: "Coast", symbol: "water.waves", color: .teal),
        Self(id: 3, title: "City", symbol: "building.2.fill", color: .orange)
    ]
}

#Preview("Parallax, selection and theme") {
    @Previewable @State var selected: Int? = 1
    HKComponentPreview {
        HKParallaxCarousel(HKCarouselPreviewItem.samples, selection: $selected, cardHeight: 240) { item in
            LinearGradient(colors: [item.color, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
                .overlay { Image(systemName: item.symbol).resizable().scaledToFit().padding(48).foregroundStyle(.white.opacity(0.5)) }
        } overlay: { item in
            Text(item.title).font(.title2.bold()).foregroundStyle(.white).padding()
        }
        HStack {
            Button("First") { selected = 1 }
            Button("Last") { selected = 3 }
        }
        HKParallaxCarousel(HKCarouselPreviewItem.samples, cardHeight: 160, parallaxStrength: 0) { item in item.color }
        HKParallaxCarousel([HKCarouselPreviewItem](), cardHeight: 160) { item in item.color }
    }
}
