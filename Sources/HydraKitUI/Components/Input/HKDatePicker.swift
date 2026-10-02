import SwiftUI

/// A themed date picker.
public struct HKDatePicker: View {
    @Environment(\.ironBitTheme) private var theme
    private let title: String
    @Binding private var date: Date

    /// Creates a date picker.
    public init(_ title: String, date: Binding<Date>) {
        self.title = title
        self._date = date
    }

    /// The date picker body.
    public var body: some View {
        DatePicker(title, selection: $date)
            .font(theme.typography.body)
            .tint(theme.colors.primary)
    }
}

#Preview {
    @Previewable @State var date = Date()
    return HKDatePicker("Ngày", date: $date).padding()
}
