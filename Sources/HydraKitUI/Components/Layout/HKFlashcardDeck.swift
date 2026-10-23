import SwiftUI

/// A Tinder-style, two-sided study deck. Tap to flip; swipe horizontally to dismiss.
/// Owns transient study/flip state; never changes items or persists learning results.
public struct HKFlashcardDeck<Data: RandomAccessCollection, Front: View, Back: View>: View where Data.Element: Identifiable {
    @Environment(\.ironBitTheme) private var theme
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var study = HKFlashcardDeckState<Data.Element.ID>()
    @State private var dismissal: Dismissal?
    @State private var revision: UInt = 0
    @State private var gesture = DragSnapshot()

    private let items: Data
    private let cardHeight: CGFloat
    private let visibleCardCount: Int
    private let swipeThreshold: CGFloat
    private let spacing: CGFloat?
    private let cornerRadius: CGFloat?
    private let showsControls: Bool
    private let leftActionLabel: Text
    private let rightActionLabel: Text
    private let onSwipe: ((Data.Element, HKFlashcardSwipeDirection) -> Void)?
    private let onComplete: (() -> Void)?
    private let front: (Data.Element) -> Front
    private let back: (Data.Element) -> Back

    private struct Dismissal: Equatable {
        let id: Data.Element.ID
        let direction: HKFlashcardSwipeDirection
        let revision: UInt
    }

    private struct DragSnapshot {
        var translation = CGSize.zero
        var isActive = false
    }

    /// - Parameters:
    ///   - items: Unique stable IDs in study order. Appended unseen IDs become available.
    ///   - cardHeight: Required face height; use ScaledMetric for large Dynamic Type.
    ///   - visibleCardCount: Number of layered faces, default 3, clamped to 1...5.
    ///   - swipeThreshold: Fraction of card width, default 0.25, clamped to 0.1...0.8.
    ///   - spacing: Peek spacing; nil uses theme spacing.sm.
    ///   - cornerRadius: Nil uses theme radius.lg.
    ///   - showsControls: Native left/flip/right buttons, default true.
    ///   - leftActionLabel: Default “Swipe left”; customize to “Review again”, etc.
    ///   - rightActionLabel: Default “Swipe right”; customize to “Learned”, etc.
    ///   - onSwipe: Once per committed card, after the dismissal animation completes.
    ///   - onComplete: After a committed swipe exhausts available cards; not on initially empty
    ///     data. Appending unseen cards can lead to a new completion after those are studied.
    ///   - front: Display-only front face, e.g. place name and local image.
    ///   - back: Display-only reverse face, e.g. English definition and example sentence.
    public init(_ items: Data, cardHeight: CGFloat, visibleCardCount: Int = 3,
                swipeThreshold: CGFloat = 0.25, spacing: CGFloat? = nil, cornerRadius: CGFloat? = nil,
                showsControls: Bool = true,
                leftActionLabel: Text = Text("Swipe left"), rightActionLabel: Text = Text("Swipe right"),
                onSwipe: ((Data.Element, HKFlashcardSwipeDirection) -> Void)? = nil,
                onComplete: (() -> Void)? = nil,
                @ViewBuilder front: @escaping (Data.Element) -> Front,
                @ViewBuilder back: @escaping (Data.Element) -> Back) {
        self.items = items
        self.cardHeight = cardHeight.isFinite ? max(0, cardHeight) : 0
        self.visibleCardCount = min(5, max(1, visibleCardCount))
        self.swipeThreshold = swipeThreshold.isFinite ? min(0.8, max(0.1, swipeThreshold)) : 0.25
        self.spacing = spacing
        self.cornerRadius = cornerRadius
        self.showsControls = showsControls
        self.leftActionLabel = leftActionLabel
        self.rightActionLabel = rightActionLabel
        self.onSwipe = onSwipe
        self.onComplete = onComplete
        self.front = front
        self.back = back
    }

    public var body: some View {
        let rows = Array(items)
        let ids = rows.map(\.id)
        let remaining = study.remaining(ids: ids)
        let visible = remaining.prefix(visibleCardCount).compactMap { id in rows.first { $0.id == id } }
        VStack(spacing: theme.spacing.md) {
            if cardHeight == 0 {
                Color.clear.frame(height: 0).accessibilityHidden(true)
            } else if let current = visible.first {
                GeometryReader { area in
                    ZStack {
                        ForEach(Array(visible.enumerated()), id: \.element.id) { depth, item in
                            Group {
                                if depth == 0 {
                                    activeCard(item, width: area.size.width)
                                } else {
                                    face(front(item), angle: 0, visible: true)
                                        .allowsHitTesting(false)
                                        .accessibilityHidden(true)
                                }
                            }
                            .scaleEffect(1 - CGFloat(depth) * 0.04, anchor: .bottom)
                            .offset(y: CGFloat(depth) * gap)
                            .zIndex(-Double(depth))
                            .transition(.identity)
                        }
                    }
                    .frame(width: area.size.width, height: cardHeight)
                    .animation(reduceMotion ? nil : theme.animations.standard, value: study.currentID)
                }
                .frame(height: cardHeight + CGFloat(max(0, visible.count - 1)) * gap)
                if showsControls { controls(current) }
            } else {
                VStack(spacing: theme.spacing.md) {
                    Label("No cards left", systemImage: "rectangle.stack")
                        .font(theme.typography.headline)
                    if !items.isEmpty {
                        Button("Start again") { restart() }.buttonStyle(.bordered)
                    }
                }
                .frame(maxWidth: .infinity, minHeight: theme.controls.largeHeight)
                .accessibilityElement(children: .contain)
            }
        }
        .foregroundStyle(theme.colors.textPrimary)
        .tint(theme.colors.primary)
        .opacity(isEnabled ? 1 : theme.controls.disabledOpacity)
        .onAppear { study.reconcile(ids: ids) }
        .onChange(of: ids) { _, newIDs in cancelMotion(); study.reconcile(ids: newIDs) }
        .onChange(of: isEnabled) { _, enabled in if !enabled { cancelMotion() } }
        .onDisappear { cancelMotion() }
    }

    private func activeCard(_ item: Data.Element, width: CGFloat) -> some View {
        let x = dismissal.map { $0.direction.sign * (width + cardHeight) } ?? drag.width
        return ZStack {
            face(front(item), angle: study.isFlipped ? 180 : 0, visible: !study.isFlipped)
            face(back(item), angle: study.isFlipped ? 0 : -180, visible: study.isFlipped)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .accessibilityRepresentation {
            Button { flip() } label: {
                if study.isFlipped { back(item) } else { front(item) }
            }
            .disabled(!isEnabled || dismissal != nil || gesture.isActive)
            .accessibilityValue(study.isFlipped ? Text("Back") : Text("Front"))
            .accessibilityHint(Text("Activate to flip the card"))
            .accessibilityActions {
                Button { swipe(item, direction: .left) } label: { leftActionLabel }
                Button { swipe(item, direction: .right) } label: { rightActionLabel }
            }
        }
        .focusable(isEnabled && dismissal == nil)
        .onKeyPress(.space) { flip(); return .handled }
        .onKeyPress(.return) { flip(); return .handled }
        .rotationEffect(.degrees(reduceMotion ? 0 : Double(min(15, max(-15, x / max(1, width) * 12)))))
        .offset(x: x, y: dismissal == nil ? drag.height * 0.08 : 0)
        .animation(reduceMotion ? nil : theme.animations.standard, value: drag)
        .modifier(HKFlashcardDragModifier(isEnabled: isEnabled && dismissal == nil, revision: revision,
            onTap: { flip() },
            onChanged: { translation in
                guard isEnabled, dismissal == nil else { return }
                var transaction = Transaction()
                transaction.disablesAnimations = true
                withTransaction(transaction) {
                    gesture.isActive = true
                    gesture.translation = abs(translation.width) > abs(translation.height) ? translation : .zero
                }
            }, onEnded: { translation, predicted in
                if let direction = HKFlashcardSwipe.resolve(translation: translation, predicted: predicted,
                                                            width: width, threshold: swipeThreshold) {
                    swipe(item, direction: direction)
                }
                gesture = DragSnapshot()
            }, onCancelled: { gesture = DragSnapshot() }))
    }

    private func face<Face: View>(_ content: Face, angle: Double, visible: Bool) -> some View {
        content.frame(maxWidth: .infinity, maxHeight: .infinity)
            .frame(height: cardHeight)
            .background(theme.colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: radius))
            .shadow(color: theme.shadows.md.color, radius: theme.shadows.md.radius,
                    x: theme.shadows.md.x, y: theme.shadows.md.y)
            .modifier(HKFlashcardFaceVisibility(angle: reduceMotion ? (visible ? 0 : 180) : angle))
            .rotation3DEffect(.degrees(reduceMotion ? 0 : angle), axis: (x: 0, y: 1, z: 0), perspective: 0.6)
    }

    private func controls(_ item: Data.Element) -> some View {
        HStack(spacing: theme.spacing.sm) {
            Button { swipe(item, direction: .left) } label: {
                leftActionLabel.frame(maxWidth: .infinity, minHeight: theme.controls.minimumTarget)
            }
            Button { flip() } label: {
                Label("Flip card", systemImage: "arrow.triangle.2.circlepath")
                    .frame(maxWidth: .infinity, minHeight: theme.controls.minimumTarget)
            }
            Button { swipe(item, direction: .right) } label: {
                rightActionLabel.frame(maxWidth: .infinity, minHeight: theme.controls.minimumTarget)
            }
        }
        .buttonStyle(.bordered)
        .disabled(dismissal != nil || gesture.isActive)
    }

    private var gap: CGFloat { sanitized(spacing ?? theme.spacing.sm) }
    private var drag: CGSize { gesture.translation }
    private var radius: CGFloat { sanitized(cornerRadius ?? theme.radius.lg) }
    private func sanitized(_ value: CGFloat) -> CGFloat { value.isFinite ? max(0, value) : 0 }

    private func flip() {
        guard isEnabled, dismissal == nil, !gesture.isActive, study.currentID != nil else { return }
        withAnimation(reduceMotion ? nil : theme.animations.standard) { study.isFlipped.toggle() }
    }

    private func swipe(_ item: Data.Element, direction: HKFlashcardSwipeDirection) {
        guard isEnabled, dismissal == nil, study.currentID == item.id, cardHeight > 0,
              items.contains(where: { $0.id == item.id }) else { return }
        let pending = Dismissal(id: item.id, direction: direction, revision: revision)
        if reduceMotion {
            dismissal = pending
            finish(item, pending: pending)
        } else {
            withAnimation(theme.animations.standard, completionCriteria: .logicallyComplete) {
                dismissal = pending
            } completion: {
                finish(item, pending: pending)
            }
        }
    }

    private func finish(_ item: Data.Element, pending: Dismissal) {
        guard dismissal == pending, revision == pending.revision else { return }
        dismissal = nil
        guard study.consume(item.id, ids: items.map(\.id)) else { return }
        let complete = study.currentID == nil
        onSwipe?(item, pending.direction)
        if complete { onComplete?() }
    }

    private func cancelMotion() { revision &+= 1; dismissal = nil; gesture = DragSnapshot() }
    private func restart() {
        guard isEnabled else { return }
        cancelMotion()
        study.restart(ids: items.map(\.id))
    }
}

/// Cull the reverse side at the 90° boundary while the flip angle interpolates.
private struct HKFlashcardFaceVisibility: AnimatableModifier {
    var angle: Double
    var animatableData: Double {
        get { angle }
        set { angle = newValue }
    }
    func body(content: Content) -> some View {
        content.opacity(cos(angle * .pi / 180) > 0 ? 1 : 0)
    }
}

#Preview("Flashcards: places in English, tap and swipe") {
    HKFlashcardDeckPreview().padding()
}

#Preview("Flashcards: light, dark and accessibility text") {
    HKComponentPreview { HKFlashcardDeckPreview() }
}

#Preview("Flashcards: disabled, gestures only and empty") {
    HKComponentPreview {
        HKFlashcardDeckPreview().disabled(true)
        HKFlashcardDeckPreview(showsControls: false)
        HKFlashcardDeckPreview(empty: true)
    }
}
