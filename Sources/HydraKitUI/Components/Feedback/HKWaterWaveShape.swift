import SwiftUI

enum HKWaterWaveMetrics {
    static func level(for percentage: Double) -> CGFloat {
        percentage.isFinite ? CGFloat(min(100, max(0, percentage)) / 100) : 0
    }

    static func duration(_ value: Double) -> Double {
        value.isFinite && value > 0 ? min(60, max(0.25, value)) : 2
    }

    static func phase(at time: Double, duration: Double) -> Double {
        guard time.isFinite else { return 0 }
        let period = Self.duration(duration)
        return time.truncatingRemainder(dividingBy: period) / period * 2 * .pi
    }

    static func rearPhase(at time: Double, duration: Double) -> Double {
        // Wrap each layer on its own complete cycle; scaling an already wrapped
        // front phase would make this slower wave jump at the front's loop boundary.
        -phase(at: time, duration: Self.duration(duration) * 1.25) + .pi / 2
    }
}

/// Only level interpolates. Timeline phase updates directly, so each clock tick
/// does not replace/restart an in-flight water-level animation.
struct HKWaterWaveShape: Shape {
    var level: CGFloat
    var phase: Double
    var amplitudeRatio: CGFloat

    var animatableData: CGFloat {
        get { level }
        set { level = newValue }
    }

    func surfaceY(at x: CGFloat, in rect: CGRect) -> CGFloat {
        let value = level.isFinite ? min(1, max(0, level)) : 0
        let ratio = amplitudeRatio.isFinite ? min(0.15, max(0, amplitudeRatio)) : 0.035
        let amplitude = rect.height * min(ratio, min(value, 1 - value) * 0.9)
        let angle = rect.width > 0 ? Double((x - rect.minX) / rect.width) * 2 * .pi : 0
        let phase = self.phase.isFinite ? self.phase : 0
        return rect.minY + rect.height * (1 - value) + amplitude * CGFloat(sin(angle + phase))
    }

    func path(in rect: CGRect) -> Path {
        guard rect.minX.isFinite, rect.minY.isFinite, rect.width.isFinite, rect.height.isFinite,
              rect.width > 0, rect.height > 0,
              level.isFinite, level > 0 else { return Path() }
        if level >= 1 { return Path(rect) }
        let steps = 120
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        for step in 0...steps {
            let x = rect.minX + rect.width * CGFloat(step) / CGFloat(steps)
            path.addLine(to: CGPoint(x: x, y: surfaceY(at: x, in: rect)))
        }
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
