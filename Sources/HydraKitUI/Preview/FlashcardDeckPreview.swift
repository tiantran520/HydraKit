import SwiftUI

private struct HKPlaceFlashcard: Identifiable {
    let id: Int
    let name: String
    let symbol: String
    let pronunciation: String
    let meaning: String
    let sentence: String
    let translation: String
    let color: Color

    static let samples = [
        Self(id: 0, name: "Library", symbol: "books.vertical.fill", pronunciation: "/ˈlaɪ.brer.i/",
             meaning: "A place where you can borrow books, read quietly, and find information.",
             sentence: "I borrowed a book from the library.", translation: "Thư viện", color: .indigo),
        Self(id: 1, name: "Museum", symbol: "building.columns.fill", pronunciation: "/mjuːˈziː.əm/",
             meaning: "A place where objects of historical, scientific, or artistic interest are displayed.",
             sentence: "We visited the museum to learn about local history.", translation: "Bảo tàng", color: .teal),
        Self(id: 2, name: "Airport", symbol: "airplane.departure", pronunciation: "/ˈer.pɔːrt/",
             meaning: "A place where aircraft take off and land, with buildings for passengers to arrive and depart.",
             sentence: "We arrived at the airport two hours before our flight.", translation: "Sân bay", color: .orange)
    ]
}

/// Offline sample used directly by the Canvas in HKFlashcardDeck.swift.
struct HKFlashcardDeckPreview: View {
    @Environment(\.ironBitTheme) private var theme
    @ScaledMetric(relativeTo: .body) private var height: CGFloat = 340
    @State private var event = "Tap to flip. Swipe left to review, right if remembered."
    private let empty: Bool
    private let showsControls: Bool

    init(empty: Bool = false, showsControls: Bool = true) {
        self.empty = empty
        self.showsControls = showsControls
    }

    var body: some View {
        VStack(spacing: theme.spacing.md) {
            Text("Places in English").font(theme.typography.headline)
            HKFlashcardDeck(empty ? [] : HKPlaceFlashcard.samples, cardHeight: height,
                            showsControls: showsControls,
                            leftActionLabel: Text("Review again"), rightActionLabel: Text("Remembered"),
                            onSwipe: { item, direction in
                event = "\(item.name): \(direction == .left ? "review again" : "remembered")"
            }, onComplete: { event = "Session complete. Start again to practise." }) { place in
                VStack(spacing: theme.spacing.lg) {
                    Image(systemName: place.symbol)
                        .resizable().scaledToFit().frame(maxHeight: 90)
                        .accessibilityHidden(true)
                    Text(place.name).font(.largeTitle.bold()).multilineTextAlignment(.center)
                    Text("What is this place?").font(theme.typography.body)
                    Text("Tap to reveal the description").font(theme.typography.caption)
                }
                .padding(theme.spacing.lg)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundStyle(.white)
                .background(LinearGradient(colors: [place.color, place.color.opacity(0.7)],
                                           startPoint: .topLeading, endPoint: .bottomTrailing))
            } back: { place in
                VStack(alignment: .leading, spacing: theme.spacing.md) {
                    Text(place.name).font(theme.typography.title)
                    Text(place.pronunciation).font(theme.typography.caption).foregroundStyle(theme.colors.textSecondary)
                    Text(place.meaning).font(theme.typography.body).fixedSize(horizontal: false, vertical: true)
                    Text(place.sentence).font(theme.typography.body).italic().fixedSize(horizontal: false, vertical: true)
                    Spacer(minLength: 0)
                    Text(place.translation).font(theme.typography.headline)
                }
                .padding(theme.spacing.lg)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .background(theme.colors.surface)
            }
            Text(event).font(theme.typography.caption).foregroundStyle(theme.colors.textSecondary)
        }
    }
}
