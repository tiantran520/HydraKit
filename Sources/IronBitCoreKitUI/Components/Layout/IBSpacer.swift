import SwiftUI

/// A fixed-size spacer component.
public struct IBSpacer: View {
    private let width: CGFloat?
    private let height: CGFloat?

    /// Creates a spacer.
    public init(width: CGFloat? = nil, height: CGFloat? = nil) {
        self.width = width
        self.height = height
    }

    /// The spacer body.
    public var body: some View {
        Spacer()
            .frame(width: width, height: height)
    }
}

#Preview {
    HStack {
        Text("A")
        IBSpacer(width: 24)
        Text("B")
    }
    .padding()
}
