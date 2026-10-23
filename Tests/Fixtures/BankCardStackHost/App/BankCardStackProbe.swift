import SwiftUI
import HydraKitUI

@main struct BankCardStackProbe: App {
    var body: some Scene { WindowGroup { Probe() } }
}

private struct Card: Identifiable { let id: Int }

private struct Probe: View {
    @State private var mode: HKBankCardStackPresentation = ProcessInfo.processInfo.arguments.contains("--expanded") ? .expanded : .collapsed
    @State private var selected: Int?
    @State private var selections = 0
    @State private var deletes = 0
    private let arguments = ProcessInfo.processInfo.arguments
    private var cards: [Card] { arguments.contains("--empty") ? [] : (0..<5).map(Card.init) }

    var body: some View {
        VStack(spacing: 16) {
            Text(String(describing: mode)).accessibilityIdentifier("mode")
            Text("\(selected ?? -1)").accessibilityIdentifier("selection")
            Text("\(selections)").accessibilityIdentifier("selections")
            Text("\(deletes)").accessibilityIdentifier("deletes")
            HKBankCardStack(cards, presentation: $mode,
                            selection: arguments.contains("--local") ? nil : $selected, cardHeight: 140,
                            onSelect: { _ in selections += 1 }, onDelete: { _ in deletes += 1 }) { item in
                VStack(alignment: .leading) {
                    Text("Card \(item.id)").font(.headline)
                    Spacer(minLength: 0)
                    Text("•••• 1234").font(.body.monospaced())
                }
                .padding(16)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .foregroundStyle(.white)
                .background(Color(hue: Double(item.id) / 6, saturation: 0.65, brightness: 0.7))
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Card \(item.id)")
            }
            .accessibilityIdentifier("bank-stack")
            .disabled(arguments.contains("--disabled"))
            HStack {
                Button("Back") { selected = nil }
                Button("Expand") { mode = .expanded }
                Button("Fan") { mode = .fanned }
                Button("Stack") { mode = .collapsed }
            }
            .buttonStyle(.bordered)
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .environment(\.layoutDirection, arguments.contains("--rtl") ? .rightToLeft : .leftToRight)
    }
}
