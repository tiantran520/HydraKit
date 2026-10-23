import SwiftUI

/// Offline preview matrix shared by the core components.
struct HKComponentPreview<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                sample("Light", scheme: .light, type: .large)
                sample("Dark", scheme: .dark, type: .large)
                sample("Accessibility", scheme: .light, type: .accessibility3)
            }
            .padding()
        }
    }

    private func sample(_ title: String, scheme: ColorScheme, type: DynamicTypeSize) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title).font(.headline)
            content()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(scheme.defaultHydraTheme.colors.background)
        .ironBitTheme(scheme.defaultHydraTheme)
        .environment(\.colorScheme, scheme)
        .environment(\.dynamicTypeSize, type)
    }
}
