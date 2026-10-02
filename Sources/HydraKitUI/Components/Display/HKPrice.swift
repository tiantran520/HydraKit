import SwiftUI

/// A localized price display.
public struct HKPrice: View {
    @Environment(\.ironBitTheme) private var theme
    private let amount: Decimal
    private let currencyCode: String

    /// Creates a price view.
    public init(_ amount: Decimal, currencyCode: String = Locale.current.currency?.identifier ?? "USD") {
        self.amount = amount
        self.currencyCode = currencyCode
    }

    /// The price body.
    public var body: some View {
        Text(formattedPrice)
            .font(theme.typography.headline)
            .foregroundStyle(theme.colors.textPrimary)
    }

    private var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        return formatter.string(from: amount as NSDecimalNumber) ?? "\(amount)"
    }
}

#Preview {
    HKPrice(Decimal(199000), currencyCode: "VND").padding()
}
