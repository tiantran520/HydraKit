import SwiftUI

/// A wrapping horizontal layout for chips and compact controls.
public struct FlowLayout: Layout {
    private let spacing: CGFloat

    /// Creates a flow layout.
    public init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }

    /// Calculates the layout size.
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = rows(in: proposal.width ?? .infinity, subviews: subviews)
        return CGSize(
            width: proposal.width ?? rows.map(\.width).max() ?? 0,
            height: rows.reduce(0) { $0 + $1.height } + CGFloat(max(rows.count - 1, 0)) * spacing
        )
    }

    /// Places subviews in wrapping rows.
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX, x > bounds.minX {
                x = bounds.minX
                y += rowHeight + spacing
                rowHeight = 0
            }
            subview.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }

    private func rows(in maxWidth: CGFloat, subviews: Subviews) -> [(width: CGFloat, height: CGFloat)] {
        var rows: [(width: CGFloat, height: CGFloat)] = []
        var current = (width: CGFloat(0), height: CGFloat(0))

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            let proposedWidth = current.width == 0 ? size.width : current.width + spacing + size.width
            if proposedWidth > maxWidth, current.width > 0 {
                rows.append(current)
                current = (size.width, size.height)
            } else {
                current.width = proposedWidth
                current.height = max(current.height, size.height)
            }
        }

        if current.width > 0 {
            rows.append(current)
        }
        return rows
    }
}
