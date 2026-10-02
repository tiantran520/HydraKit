#if DEBUG
#if canImport(SwiftUI)
import SwiftUI

/// A lightweight wrapper for rendering preview content with debug dependencies.
public struct PreviewContainer<Content: View>: View {
    private let environment: HKAppEnvironment
    private let mockDataProvider: HKMockDataProvider
    private let content: (HKMockDataProvider, HKAppEnvironment) -> Content

    /// Creates a preview container.
    /// - Parameters:
    ///   - environment: The environment exposed to preview content.
    ///   - mockDataProvider: The mock data provider for preview content.
    ///   - content: A closure that creates the preview content.
    public init(
        environment: HKAppEnvironment = .dev,
        mockDataProvider: HKMockDataProvider = HKMockDataProvider(),
        @ViewBuilder content: @escaping (HKMockDataProvider, HKAppEnvironment) -> Content
    ) {
        self.environment = environment
        self.mockDataProvider = mockDataProvider
        self.content = content
    }

    /// The preview body.
    public var body: some View {
        content(mockDataProvider, environment)
    }
}
#endif
#endif
