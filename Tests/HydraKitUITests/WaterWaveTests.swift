import SwiftUI
import XCTest
@testable import HydraKitUI
#if os(macOS)
import AppKit
#endif

final class WaterWaveTests: XCTestCase {
    func testPercentageIsClampedAndInvalidInputBecomesEmpty() {
        XCTAssertEqual(HKWaterWaveMetrics.level(for: 50), 0.5)
        XCTAssertEqual(HKWaterWaveMetrics.level(for: -20), 0)
        XCTAssertEqual(HKWaterWaveMetrics.level(for: 150), 1)
        XCTAssertEqual(HKWaterWaveMetrics.level(for: .nan), 0)
        XCTAssertEqual(HKWaterWaveMetrics.level(for: .infinity), 0)
    }

    func testWavePhaseIsPeriodicAndDurationIsSafe() {
        XCTAssertEqual(HKWaterWaveMetrics.phase(at: 0, duration: 2), 0)
        XCTAssertEqual(HKWaterWaveMetrics.phase(at: 1, duration: 2), .pi, accuracy: 0.001)
        XCTAssertEqual(HKWaterWaveMetrics.phase(at: 2, duration: 2), 0, accuracy: 0.001)
        XCTAssertTrue(HKWaterWaveMetrics.phase(at: 1, duration: 0).isFinite)
        XCTAssertEqual(HKWaterWaveMetrics.phase(at: .infinity, duration: 2), 0)
    }

    func testRearWaveStaysContinuousWhenFrontCycleWraps() {
        let rect = CGRect(x: 0, y: 0, width: 200, height: 200)
        let before = HKWaterWaveShape(level: 0.5, phase: HKWaterWaveMetrics.rearPhase(at: 1.999, duration: 2), amplitudeRatio: 0.035)
        let after = HKWaterWaveShape(level: 0.5, phase: HKWaterWaveMetrics.rearPhase(at: 2.001, duration: 2), amplitudeRatio: 0.035)
        XCTAssertEqual(before.surfaceY(at: 50, in: rect), after.surfaceY(at: 50, in: rect), accuracy: 0.1)
    }

    func testZeroIsTrulyEmptyAndHundredIsCompletelyFull() {
        let rect = CGRect(x: 10, y: 20, width: 200, height: 200)
        XCTAssertTrue(HKWaterWaveShape(level: 0, phase: 1, amplitudeRatio: 0.035).path(in: rect).isEmpty)
        XCTAssertEqual(HKWaterWaveShape(level: 1, phase: 1, amplitudeRatio: 0.035).path(in: rect).boundingRect, rect)
    }

    func testLevelAndPhaseMoveSurfaceAtExpectedHeight() {
        let rect = CGRect(x: 0, y: 0, width: 200, height: 200)
        let wave = HKWaterWaveShape(level: 0.5, phase: 0, amplitudeRatio: 0.035)
        XCTAssertEqual(wave.surfaceY(at: 0, in: rect), 100, accuracy: 0.001)
        XCTAssertEqual(wave.surfaceY(at: 50, in: rect), 107, accuracy: 0.001)
        let high = HKWaterWaveShape(level: 0.75, phase: 0, amplitudeRatio: 0)
        XCTAssertEqual(high.surfaceY(at: 80, in: rect), 50, accuracy: 0.001)
    }

    func testWaveTapersNearEndpointsWithoutLeakingOutsideContainer() {
        let rect = CGRect(x: 0, y: 0, width: 200, height: 200)
        for level: CGFloat in [0.01, 0.5, 0.99] {
            let shape = HKWaterWaveShape(level: level, phase: 2, amplitudeRatio: 0.15)
            for x: CGFloat in stride(from: 0, through: 200, by: 10) {
                XCTAssertGreaterThanOrEqual(shape.surfaceY(at: x, in: rect), 0)
                XCTAssertLessThanOrEqual(shape.surfaceY(at: x, in: rect), 200)
            }
        }
        XCTAssertTrue(HKWaterWaveShape(level: 0.5, phase: 0, amplitudeRatio: 0.035).path(in: .zero).isEmpty)
    }

    #if os(macOS)
    @MainActor
    func testRenderedHalfFillHasEmptyTopAndProvidedColorAtBottom() throws {
        let bitmap = try render(percentage: 50, color: Color(red: 1, green: 0, blue: 0))
        // Compare the rendered bitmap's RGB samples, not a second ColorSync conversion.
        let top = try XCTUnwrap(bitmap.colorAt(x: 100, y: 25))
        let bottom = try XCTUnwrap(bitmap.colorAt(x: 100, y: 175))
        XCTAssertGreaterThan(top.greenComponent, 0.9)
        XCTAssertGreaterThan(top.blueComponent, 0.9)
        XCTAssertGreaterThan(bottom.redComponent, 0.9)
        XCTAssertLessThan(bottom.greenComponent, 0.1)
    }

    @MainActor
    func testRenderedColorCanChangeAndEndpointsAreExact() throws {
        let empty = try render(percentage: 0, color: .red)
        let full = try render(percentage: 100, color: .blue)
        let emptyCenter = try XCTUnwrap(empty.colorAt(x: 100, y: 100))
        let fullCenter = try XCTUnwrap(full.colorAt(x: 100, y: 100))
        XCTAssertGreaterThan(emptyCenter.redComponent, 0.9)
        XCTAssertGreaterThan(emptyCenter.greenComponent, 0.9)
        XCTAssertGreaterThan(fullCenter.blueComponent, 0.9)
        XCTAssertLessThan(fullCenter.redComponent, 0.1)
    }

    @MainActor
    private func render(percentage: Double, color: Color) throws -> NSBitmapImageRep {
        _ = NSApplication.shared
        let content = HKWaterWave(percentage: percentage, color: color, backgroundColor: .white,
                                  showsPercentage: false, isAnimating: false)
            .frame(width: 200, height: 200)
        let renderer = ImageRenderer(content: content)
        renderer.scale = 1
        let image = try XCTUnwrap(renderer.nsImage)
        let data = try XCTUnwrap(image.tiffRepresentation)
        return try XCTUnwrap(NSBitmapImageRep(data: data))
    }
    #endif
}
