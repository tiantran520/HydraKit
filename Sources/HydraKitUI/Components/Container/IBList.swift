import SwiftUI

/// A simple themed list container.
public struct IBList<Data: RandomAccessCollection, Row: View>: View where Data.Element: Identifiable {
    private let data: Data
    private let row: (Data.Element) -> Row

    /// Creates a list.
    public init(_ data: Data, @ViewBuilder row: @escaping (Data.Element) -> Row) {
        self.data = data
        self.row = row
    }

    /// The list body.
    public var body: some View {
        List(data) { item in
            row(item)
        }
        .listStyle(.plain)
    }
}

#Preview {
    struct Item: Identifiable { let id = UUID(); let title: String }
    return IBList([Item(title: "Một"), Item(title: "Hai")]) { item in
        Text(item.title)
    }
}
