import SwiftUI
import HydraKitUI

@main struct CarouselGestureProbe: App {
    var body: some Scene { WindowGroup { Probe() } }
}

private struct Item: Identifiable { let id: Int }

private struct Probe: View {
    @State private var selected: Int? = 4
    @State private var narrowViewport = false
    private let arguments = ProcessInfo.processInfo.arguments
    var body: some View {
        VStack(spacing: 24) {
            Text("\(selected ?? -1)").accessibilityIdentifier("selection")
            HKParallaxCarousel((0..<9).map(Item.init), selection: $selected, cardHeight: 220,
                               cardWidthRatio: arguments.contains("--small-cards") ? 0.28 : 0.85,
                               spacing: 12) { item in
                Color(hue: Double(item.id) / 9, saturation: 0.65, brightness: 0.8)
            } overlay: { item in
                ZStack(alignment: .bottomLeading) {
                    CardFrameProbe(id: item.id).allowsHitTesting(false)
                    Text("Card \(item.id)").padding().foregroundStyle(.white).accessibilityHidden(true)
                }
            }
            .frame(width: narrowViewport ? 240 : 360)
            Button("Resize") { narrowViewport.toggle() }
            Button("Last") { selected = 8 }
            Button("First") { selected = 0 }
        }
        .environment(\.layoutDirection, arguments.contains("--rtl") ? .rightToLeft : .leftToRight)
    }
}

// Native accessibility bounds measure the whole card, rather than Text's glyph bounds.
private struct CardFrameProbe: UIViewRepresentable {
    let id: Int
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.isAccessibilityElement = true
        return view
    }
    func updateUIView(_ view: UIView, context: Context) {
        view.accessibilityIdentifier = "card-\(id)"
        view.accessibilityLabel = "Card \(id)"
    }
}
