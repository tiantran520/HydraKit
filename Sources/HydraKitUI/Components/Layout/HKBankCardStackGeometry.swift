import SwiftUI

enum HKBankCardStackSwipe: Equatable {
    case left, right, up, down

    static func resolve(translation: CGSize, predicted: CGSize, threshold: CGFloat) -> Self? {
        guard translation.width.isFinite, translation.height.isFinite,
              max(abs(translation.width), abs(translation.height)) >= 12 else { return nil }
        let horizontal = abs(translation.width) > abs(translation.height)
        let actual = horizontal ? translation.width : translation.height
        let projected = horizontal ? predicted.width : predicted.height
        guard abs(actual) >= threshold || projected.isFinite && abs(projected) >= threshold && actual * projected > 0 else { return nil }
        return horizontal ? (actual < 0 ? .left : .right) : (actual < 0 ? .up : .down)
    }
}

enum HKBankCardStackRules {
    static func next(_ swipe: HKBankCardStackSwipe, from state: HKBankCardStackPresentation) -> HKBankCardStackPresentation {
        switch (state, swipe) {
        case (.fanned, .left): return .collapsed
        case (.collapsed, .right), (.expanded, .right): return .fanned
        case (.collapsed, .down): return .expanded
        case (.expanded, .up): return .collapsed
        default: return state
        }
    }
}

struct HKBankCardStackGeometry {
    struct Pose {
        var scale: CGFloat = 1
        var angle: Double = 0
        var x: CGFloat = 0
        var y: CGFloat = 0
    }

    let cardWidth: CGFloat
    let cardHeight: CGFloat
    let poses: [Pose]
    let fitScale: CGFloat
    let origin: CGPoint
    let height: CGFloat
    let fanAnchor: Bool
    private let selectedIndex: Int?

    init(width: CGFloat, cardHeight: CGFloat, count: Int, presentation: HKBankCardStackPresentation,
         spacing: CGFloat, inset: CGFloat, selectedIndex: Int?) {
        let width = width.isFinite ? max(0, width) : 0
        self.cardWidth = max(0, width - 2 * min(width / 4, inset.isFinite ? max(0, inset) : 0))
        self.cardHeight = cardHeight.isFinite ? max(0, cardHeight) : 0
        self.selectedIndex = selectedIndex.flatMap { (0..<max(0, count)).contains($0) ? $0 : nil }
        self.fanAnchor = presentation == .fanned && self.selectedIndex == nil && count > 1
        let gap = spacing.isFinite ? max(0, spacing) : 0
        let height = self.cardHeight
        let focusedIndex = self.selectedIndex
        self.poses = (0..<max(0, count)).map { depth in
            if depth == focusedIndex { return Pose() }
            let behind = CGFloat(max(0, count - 1 - depth))
            let scale = max(0.65, 1 - CGFloat(depth) * 0.05)
            switch presentation {
            case .collapsed:
                return Pose(scale: scale, y: behind * gap)
            case .expanded:
                return Pose(scale: scale, y: behind * (height * 0.5 + gap * 0.5))
            case .fanned:
                let fraction = Double(depth) / Double(max(1, count - 1))
                return Pose(scale: scale, angle: count > 1 ? -15 + 25 * fraction : 0,
                            x: CGFloat(depth) * gap * 0.5, y: behind * height * 0.25)
            }
        }
        var union = CGRect.null
        for index in poses.indices where self.selectedIndex == nil || index == self.selectedIndex {
            union = union.union(Self.rect(width: self.cardWidth, height: self.cardHeight,
                                          pose: poses[index], fanAnchor: fanAnchor))
        }
        if union.isNull || width == 0 || self.cardHeight == 0 {
            self.fitScale = 1
            self.origin = .zero
            self.height = 0
        } else {
            self.fitScale = union.width > 0 ? min(1, width / union.width) : 1
            self.origin = CGPoint(x: (width - union.width * fitScale) / 2 - union.minX * fitScale,
                                  y: -union.minY * fitScale)
            self.height = union.height * fitScale
        }
    }

    func bounds(of index: Int) -> CGRect {
        let rect = Self.rect(width: cardWidth, height: cardHeight, pose: poses[index], fanAnchor: fanAnchor)
        return CGRect(x: origin.x + rect.minX * fitScale, y: origin.y + rect.minY * fitScale,
                      width: rect.width * fitScale, height: rect.height * fitScale)
    }

    func hitTest(_ point: CGPoint) -> Int? {
        poses.indices.first { (selectedIndex == nil || $0 == selectedIndex) && bounds(of: $0).contains(point) }
    }

    private static func rect(width: CGFloat, height: CGFloat, pose: Pose, fanAnchor: Bool) -> CGRect {
        let anchorX = fanAnchor ? width : width / 2
        let radians = pose.angle * .pi / 180
        let points = [CGPoint.zero, CGPoint(x: width, y: 0), CGPoint(x: 0, y: height), CGPoint(x: width, y: height)].map { point in
            let x = (point.x - anchorX) * pose.scale
            let y = point.y * pose.scale
            return CGPoint(x: anchorX + x * cos(radians) - y * sin(radians) + pose.x,
                           y: x * sin(radians) + y * cos(radians) + pose.y)
        }
        let minX = points.map(\.x).min() ?? 0
        let maxX = points.map(\.x).max() ?? 0
        let minY = points.map(\.y).min() ?? 0
        let maxY = points.map(\.y).max() ?? 0
        return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }
}
