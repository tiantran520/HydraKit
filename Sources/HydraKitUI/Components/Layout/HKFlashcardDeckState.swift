import SwiftUI

/// Physical swipe directions. The caller decides whether these mean review/learned, etc.
public enum HKFlashcardSwipeDirection: Sendable, Equatable {
    case left, right

    var sign: CGFloat { self == .left ? -1 : 1 }
}

enum HKFlashcardSwipe {
    static func resolve(translation: CGSize, predicted: CGSize, width: CGFloat,
                        threshold: CGFloat) -> HKFlashcardSwipeDirection? {
        guard width.isFinite, width > 0, translation.width.isFinite, translation.height.isFinite,
              abs(translation.width) >= 12, abs(translation.width) > abs(translation.height) else { return nil }
        let ratio = threshold.isFinite ? min(0.8, max(0.1, threshold)) : 0.25
        let deliberate = abs(translation.width) >= width * ratio
        let flick = predicted.width.isFinite && abs(predicted.width) >= width * ratio &&
            translation.width * predicted.width > 0
        guard deliberate || flick else { return nil }
        return translation.width < 0 ? .left : .right
    }
}

/// Study-session state, independent of the caller's content and persistence logic.
struct HKFlashcardDeckState<ID: Hashable>: Equatable {
    private(set) var currentID: ID?
    private var consumed: Set<ID> = []
    var isFlipped = false

    func remaining(ids: [ID]) -> [ID] {
        let unseen = ids.filter { !consumed.contains($0) }
        guard let currentID, unseen.contains(currentID) else { return unseen }
        return [currentID] + unseen.filter { $0 != currentID }
    }

    mutating func reconcile(ids: [ID]) {
        consumed.formIntersection(Set(ids))
        let next = remaining(ids: ids).first
        if currentID != next { isFlipped = false }
        currentID = next
    }

    @discardableResult
    mutating func consume(_ id: ID, ids: [ID]) -> Bool {
        guard currentID == id, ids.contains(id), !consumed.contains(id) else { return false }
        consumed.insert(id)
        reconcile(ids: ids)
        isFlipped = false
        return true
    }

    mutating func restart(ids: [ID]) {
        consumed.removeAll()
        currentID = ids.first
        isFlipped = false
    }
}
