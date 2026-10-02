import Foundation
import SwiftUI

/// Coordinates a sequence of flow steps.
@MainActor
public final class HKFlowCoordinator<Step: FlowStep>: ObservableObject {
    /// All configured steps.
    public let steps: [Step]
    /// The current step index.
    @Published public private(set) var currentIndex: Int

    /// The current step.
    public var currentStep: Step? {
        guard steps.indices.contains(currentIndex) else { return nil }
        return steps[currentIndex]
    }

    /// Creates a flow coordinator.
    public init(steps: [Step], currentIndex: Int = 0) {
        self.steps = steps
        self.currentIndex = min(max(currentIndex, 0), max(steps.count - 1, 0))
    }

    /// Advances to the next step.
    public func next() {
        guard currentIndex < steps.count - 1 else { return }
        currentIndex += 1
    }

    /// Moves back to the previous step.
    public func previous() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
    }

    /// Jumps to a specific step.
    public func go(to step: Step) {
        guard let index = steps.firstIndex(of: step) else { return }
        currentIndex = index
    }

    /// Resets the flow to the first step.
    public func reset() {
        currentIndex = 0
    }
}
