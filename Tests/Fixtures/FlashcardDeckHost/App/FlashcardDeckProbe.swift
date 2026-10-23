import SwiftUI
import HydraKitUI

@main struct FlashcardDeckProbe: App {
    var body: some Scene { WindowGroup { Probe() } }
}

private struct Card: Identifiable { let id: Int }

private struct Probe: View {
    @State private var cards = (0..<3).map(Card.init)
    @State private var swipes = 0
    @State private var completions = 0
    @State private var lastSwipe = "none"
    private let arguments = ProcessInfo.processInfo.arguments

    var body: some View {
        Group {
            if arguments.contains("--scroll") {
                ScrollView {
                    content
                    Color.clear.frame(height: 650)
                    Text("Page end").accessibilityIdentifier("page-end")
                }
            } else {
                content
            }
        }
        .environment(\.layoutDirection, arguments.contains("--rtl") ? .rightToLeft : .leftToRight)
    }

    private var content: some View {
        VStack(spacing: 16) {
            Text("\(swipes)").accessibilityIdentifier("swipes")
            Text("\(completions)").accessibilityIdentifier("completions")
            Text(lastSwipe).accessibilityIdentifier("last-swipe")
            HKFlashcardDeck(arguments.contains("--empty") ? [] : cards, cardHeight: 300,
                            leftActionLabel: Text("Review"), rightActionLabel: Text("Learned"),
                            onSwipe: { card, direction in
                swipes += 1
                lastSwipe = "\(card.id):\(direction == .left ? "left" : "right")"
                if arguments.contains("--remove-on-swipe") { cards.removeAll { $0.id == card.id } }
            }, onComplete: { completions += 1 }) { card in
                VStack {
                    Image(systemName: "building.columns.fill").font(.system(size: 60)).accessibilityHidden(true)
                    Text("Place \(card.id)").font(.largeTitle)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundStyle(.white).background(.indigo)
                .accessibilityElement(children: .ignore).accessibilityLabel("Place \(card.id)")
            } back: { card in
                VStack(alignment: .leading, spacing: 20) {
                    Text("Description \(card.id)").font(.title)
                    Text("A place where people explore art, learn about history, and discover new ideas.")
                    Text("We visited the museum last weekend.").italic()
                }
                .padding(24)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.mint.opacity(0.2))
                .accessibilityElement(children: .ignore).accessibilityLabel("Description \(card.id)")
            }
            .disabled(arguments.contains("--disabled"))
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: arguments.contains("--scroll") ? nil : .infinity, alignment: .top)
    }
}
