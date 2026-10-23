import SwiftUI

private struct HKBankCardPreviewItem: Identifiable {
    let id: Int
    let title: String
    let color: Color
    static let samples = [
        Self(id: 0, title: "Everyday wallet", color: .indigo),
        Self(id: 1, title: "Travel card", color: .teal),
        Self(id: 2, title: "Savings", color: .orange),
        Self(id: 3, title: "A longer localized bank account name", color: .purple),
        Self(id: 4, title: "Add bank card", color: .gray)
    ]
}

/// Internal, offline sample shared by the component's Canvas and the preview matrix.
struct HKBankCardStackPreview: View {
    @State var mode: HKBankCardStackPresentation = .collapsed
    @State private var selectedID: Int?
    @State private var request = ""
    @ScaledMetric(relativeTo: .body) private var height: CGFloat = 180

    init(mode: HKBankCardStackPresentation = .collapsed) {
        _mode = State(initialValue: mode)
    }

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button("Stack") { selectedID = nil; mode = .collapsed }
                Button("Fan") { selectedID = nil; mode = .fanned }
                Button("Expand") { selectedID = nil; mode = .expanded }
                if selectedID != nil { Button("Back") { selectedID = nil } }
            }
            .buttonStyle(.bordered)
            HKBankCardStack(HKBankCardPreviewItem.samples, presentation: $mode, selection: $selectedID,
                            cardHeight: height, onSelect: { item in
                if item.id == 4 { selectedID = nil; request = "Present your bank-linking flow here" }
            }, onDelete: { item in request = "Confirm removal of \(item.title) in the parent screen" }) { item in
                VStack(alignment: .leading, spacing: 12) {
                    Label(item.title, systemImage: item.id == 4 ? "plus.circle" : "creditcard.fill")
                        .font(.headline).lineLimit(2)
                    Spacer(minLength: 0)
                    if item.id != 4 {
                        Text("••••  1234").font(.body.monospaced())
                        Text("DEMO CARDHOLDER").font(.caption)
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .foregroundStyle(.white)
                .background(LinearGradient(colors: [item.color, item.color.opacity(0.7)],
                                           startPoint: .topLeading, endPoint: .bottomTrailing))
            }
            if !request.isEmpty { Text(request).font(.caption) }
        }
    }
}

#Preview("Bank stack: gestures, selection, light, dark and Dynamic Type") {
    HKComponentPreview { HKBankCardStackPreview() }
}

#Preview("Bank stack: expanded and disabled") {
    HKComponentPreview {
        HKBankCardStackPreview(mode: .expanded)
        HKBankCardStackPreview().disabled(true)
    }
}

#Preview("Bank stack: empty and single card") {
    HKComponentPreview {
        HKBankCardStack([HKBankCardPreviewItem](), cardHeight: 180) { Text($0.title) }
        HKBankCardStack(Array(HKBankCardPreviewItem.samples.prefix(1)), cardHeight: 180) {
            Text($0.title).padding().frame(maxWidth: .infinity, maxHeight: .infinity).background($0.color)
        }
    }
}
