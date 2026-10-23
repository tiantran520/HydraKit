import SwiftUI

/// Rejects vertical intent before iOS recognizes a pan. Other platforms use SwiftUI.
struct HKFlashcardDragModifier: ViewModifier {
    let isEnabled: Bool
    let revision: UInt
    let onTap: () -> Void
    let onChanged: (CGSize) -> Void
    let onEnded: (CGSize, CGSize) -> Void
    let onCancelled: () -> Void
    #if !os(iOS)
    @GestureState private var active = false
    #endif

    @ViewBuilder
    func body(content: Content) -> some View {
        #if os(iOS)
        content.overlay {
            HKFlashcardInteractionSurface(isEnabled: isEnabled, revision: revision, onTap: onTap,
                                          onChanged: onChanged, onEnded: onEnded, onCancelled: onCancelled)
        }
        #else
        content.onTapGesture { if isEnabled { onTap() } }
            .simultaneousGesture(DragGesture(minimumDistance: 12)
                .updating($active) { _, state, _ in if isEnabled { state = true } }
                .onChanged { if isEnabled { onChanged($0.translation) } }
                .onEnded { if isEnabled { onEnded($0.translation, $0.predictedEndTranslation) } })
            .onChange(of: active) { _, newValue in if !newValue { onCancelled() } }
        #endif
    }
}

#if os(iOS)
import UIKit

/// Transparent card-local input surface. No recognizers are installed on windows
/// or hosting ancestors, so unrelated overlays retain their normal hit-testing.
private struct HKFlashcardInteractionSurface: UIViewRepresentable {
    let isEnabled: Bool
    let revision: UInt
    let onTap: () -> Void
    let onChanged: (CGSize) -> Void
    let onEnded: (CGSize, CGSize) -> Void
    let onCancelled: () -> Void

    func makeCoordinator() -> Coordinator { Coordinator(self) }
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.isAccessibilityElement = false
        view.accessibilityElementsHidden = true
        context.coordinator.install(on: view)
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) { context.coordinator.update(self, view: uiView) }
    static func dismantleUIView(_ uiView: UIView, coordinator: Coordinator) { coordinator.detach() }

    @MainActor
    final class Coordinator: NSObject, UIGestureRecognizerDelegate {
        private var parent: HKFlashcardInteractionSurface
        private weak var view: UIView?
        private var suppressEvents = false
        private lazy var pan: UIPanGestureRecognizer = {
            let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            recognizer.maximumNumberOfTouches = 1
            recognizer.delegate = self
            return recognizer
        }()
        private lazy var tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))

        init(_ parent: HKFlashcardInteractionSurface) { self.parent = parent }

        func install(on view: UIView) {
            self.view = view
            view.addGestureRecognizer(pan)
            view.addGestureRecognizer(tap)
            tap.require(toFail: pan)
            update(parent, view: view)
        }

        func update(_ newValue: HKFlashcardInteractionSurface, view: UIView) {
            let invalidated = parent.revision != newValue.revision
            parent = newValue
            if invalidated || !newValue.isEnabled {
                suppressEvents = true
                pan.isEnabled = false
                tap.isEnabled = false
                suppressEvents = false
            }
            if pan.isEnabled != newValue.isEnabled { pan.isEnabled = newValue.isEnabled }
            if tap.isEnabled != newValue.isEnabled { tap.isEnabled = newValue.isEnabled }
            view.isUserInteractionEnabled = newValue.isEnabled
        }

        func detach() {
            suppressEvents = true
            view?.removeGestureRecognizer(pan)
            view?.removeGestureRecognizer(tap)
            view = nil
        }

        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            guard parent.isEnabled, let view else { return false }
            let velocity = pan.velocity(in: view)
            let translation = pan.translation(in: view)
            let intent = velocity == .zero ? translation : velocity
            return intent.x.isFinite && intent.y.isFinite && abs(intent.x) > abs(intent.y)
        }

        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                               shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            otherGestureRecognizer is UIPanGestureRecognizer && otherGestureRecognizer.view is UIScrollView
        }

        @objc private func handleTap(_ recognizer: UITapGestureRecognizer) {
            guard !suppressEvents, parent.isEnabled, recognizer.state == .ended else { return }
            parent.onTap()
        }

        @objc private func handlePan(_ recognizer: UIPanGestureRecognizer) {
            guard !suppressEvents, parent.isEnabled, let view else { return }
            let point = recognizer.translation(in: view)
            let translation = CGSize(width: point.x, height: point.y)
            switch recognizer.state {
            case .began, .changed:
                parent.onChanged(translation)
            case .ended:
                let velocity = recognizer.velocity(in: view)
                let predicted = CGSize(width: point.x + velocity.x * 0.15, height: point.y + velocity.y * 0.15)
                parent.onEnded(translation, predicted)
            case .cancelled, .failed:
                parent.onCancelled()
            default: break
            }
        }
    }
}
#endif
