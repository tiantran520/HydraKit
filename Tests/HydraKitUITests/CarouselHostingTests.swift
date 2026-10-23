#if os(macOS)
import AppKit
import SwiftUI
import XCTest
@testable import HydraKitUI

final class CarouselHostingTests: XCTestCase {
    @MainActor private var windows: [NSWindow] = []

    @MainActor
    func testSelectionScrollsNativeViewportToNextCard() async throws {
        let model = Model()
        let host = makeHost(Harness(model: model), width: 360)
        let scroll = try XCTUnwrap(findScroll(in: host))
        try await waitUntil { scroll.contentView.bounds.minX > 100 }
        let middleOrigin = scroll.contentView.bounds.minX
        XCTAssertEqual(middleOrigin + scroll.contentInsets.left, 300, accuracy: 2)
        XCTAssertEqual(model.selection, 2)
        model.selection = 3
        try await waitUntil { scroll.contentView.bounds.minX > middleOrigin + 200 }
        XCTAssertEqual(scroll.contentView.bounds.minX - middleOrigin, 300, accuracy: 2)
        XCTAssertEqual(model.selection, 3)
        try savePreview(host, name: "carousel-last-light")
        // Gesture limits must not constrain navigation initiated by the parent.
        model.selection = 1
        try await waitUntil { abs(scroll.contentView.bounds.minX + scroll.contentInsets.left) < 2 }
        XCTAssertEqual(model.selection, 1)
    }

    @MainActor
    func testFirstAndLastCardsStayCenteredInRTL() async throws {
        let model = Model()
        model.selection = 3
        let host = makeHost(Harness(model: model).environment(\.layoutDirection, .rightToLeft), width: 360)
        let scroll = try XCTUnwrap(findScroll(in: host))
        try await waitUntil { model.selection == 3 && abs(scroll.contentView.bounds.minX + scroll.contentInsets.left) < 2 }
        XCTAssertEqual(scroll.contentView.bounds.minX + scroll.contentInsets.left, 0, accuracy: 2)
        model.selection = 1
        try await waitUntil { scroll.contentView.bounds.minX > 500 }
        XCTAssertEqual(scroll.contentView.bounds.minX + scroll.contentInsets.left, 600, accuracy: 2)
        XCTAssertEqual(model.selection, 1)
        try savePreview(host, name: "carousel-first-rtl")
    }

    @MainActor
    func testOverlayReceivesHitTestingAndButtonCallbacks() throws {
        var activations = 0
        let carousel = HKParallaxCarousel([Item(id: 1)], cardHeight: 180) { _ in
            Color.indigo
        } overlay: { _ in
            ProbeButton { activations += 1 }.frame(width: 80, height: 32).padding(16)
        }
        let host = makeHost(carousel, width: 360)
        let button = try XCTUnwrap(findButton(in: host))
        // AppKit hitTest takes its point in the receiver's superview coordinates.
        let center = button.convert(NSPoint(x: button.bounds.midX, y: button.bounds.midY), to: host.superview)
        let hit = host.hitTest(center)
        XCTAssertTrue(hit === button || hit?.isDescendant(of: button) == true,
                      "The moving background must not disable overlay hit testing")
        button.performClick(nil)
        XCTAssertEqual(activations, 1)
    }

    @MainActor
    func testEmptyDataCollapsesAndClearsStaleSelection() async throws {
        let model = Model()
        let host = makeHost(Harness(model: model, items: []), width: 360)
        try await waitUntil { model.selection == nil }
        XCTAssertEqual(host.fittingSize.height, 0, accuracy: 0.5)
    }

    @MainActor
    func testDataReorderingAndRemovalKeepNativePositionConsistentWithSelection() async throws {
        let model = Model()
        let host = makeHost(Harness(model: model), width: 360)
        let scroll = try XCTUnwrap(findScroll(in: host))
        try await waitUntil { abs(scroll.contentView.bounds.minX + scroll.contentInsets.left - 300) < 2 }
        model.items = [Item(id: 2), Item(id: 3), Item(id: 1)]
        try await waitUntil { model.selection == 2 && abs(scroll.contentView.bounds.minX + scroll.contentInsets.left) < 2 }
        XCTAssertEqual(scroll.contentView.bounds.minX + scroll.contentInsets.left, 0, accuracy: 2, "Reordered position")
        XCTAssertEqual(model.selection, 2)
        model.items = [Item(id: 3), Item(id: 1)]
        try await waitUntil { model.selection == 3 && abs(scroll.contentView.bounds.minX + scroll.contentInsets.left) < 2 }
        XCTAssertEqual(scroll.contentView.bounds.minX + scroll.contentInsets.left, 0, accuracy: 2, "Removed position")
        XCTAssertEqual(model.selection, 3)
    }

    @MainActor
    func testResizingKeepsNonFirstSelectionCentered() async throws {
        let model = Model()
        let host = makeHost(Harness(model: model), width: 360)
        let scroll = try XCTUnwrap(findScroll(in: host))
        try await waitUntil { abs(scroll.contentView.bounds.minX + scroll.contentInsets.left - 300) < 2 }
        model.width = 240
        try await waitUntil { abs(scroll.contentView.bounds.minX + scroll.contentInsets.left - 204) < 2 }
        XCTAssertEqual(model.selection, 2)
    }

    @MainActor
    func testCarouselRespectsViewportAndConfiguredHeight() {
        let items = [Item(id: 1), Item(id: 2)]
        for width: CGFloat in [180, 768] {
            let carousel = HKParallaxCarousel(items, cardHeight: 180) { _ in Color.blue }
            let host = makeHost(carousel, width: width)
            XCTAssertEqual(host.fittingSize.width, width, accuracy: 0.5)
            XCTAssertEqual(host.fittingSize.height, 180, accuracy: 0.5)
        }
    }

    @MainActor
    private func makeHost<V: View>(_ content: V, width: CGFloat) -> NSHostingView<some View> {
        _ = NSApplication.shared
        let host = NSHostingView(rootView: content.frame(width: width))
        host.frame = NSRect(x: 0, y: 0, width: width, height: 180)
        let window = NSWindow(contentRect: host.frame, styleMask: [.borderless], backing: .buffered, defer: false)
        window.contentView = host
        windows.append(window)
        host.layoutSubtreeIfNeeded()
        window.displayIfNeeded()
        return host
    }

    @MainActor
    private func findScroll(in view: NSView) -> NSScrollView? {
        (view as? NSScrollView) ?? view.subviews.lazy.compactMap { self.findScroll(in: $0) }.first
    }

    @MainActor
    private func findButton(in view: NSView) -> NSButton? {
        (view as? NSButton) ?? view.subviews.lazy.compactMap { self.findButton(in: $0) }.first
    }

    @MainActor
    private func waitUntil(_ condition: () -> Bool) async throws {
        let deadline = ContinuousClock.now + .seconds(2)
        while !condition(), ContinuousClock.now < deadline {
            try await Task.sleep(for: .milliseconds(20))
        }
        XCTAssertTrue(condition(), "Native scroll position did not settle before the deadline")
    }

    @MainActor
    private func savePreview(_ host: NSView, name: String) throws {
        guard let output = ProcessInfo.processInfo.environment["HYDRAKIT_PREVIEW_OUTPUT"] else { return }
        host.layoutSubtreeIfNeeded()
        let bitmap = try XCTUnwrap(host.bitmapImageRepForCachingDisplay(in: host.bounds))
        host.cacheDisplay(in: host.bounds, to: bitmap)
        let data = try XCTUnwrap(bitmap.representation(using: .png, properties: [:]))
        try data.write(to: URL(fileURLWithPath: output).appendingPathComponent("\(name).png"))
    }

    private struct Item: Identifiable { let id: Int }

    private struct ProbeButton: NSViewRepresentable {
        let action: @MainActor () -> Void
        func makeCoordinator() -> Coordinator { Coordinator(action: action) }
        func makeNSView(context: Context) -> NSButton {
            NSButton(title: "Open", target: context.coordinator, action: #selector(Coordinator.activate))
        }
        func updateNSView(_ nsView: NSButton, context: Context) {}

        @MainActor final class Coordinator: NSObject {
            let action: @MainActor () -> Void
            init(action: @escaping @MainActor () -> Void) { self.action = action }
            @objc func activate() { action() }
        }
    }

    @MainActor
    private final class Model: ObservableObject {
        @Published var selection: Int? = 2
        @Published var items = [Item(id: 1), Item(id: 2), Item(id: 3)]
        @Published var width: CGFloat?
    }

    private struct Harness: View {
        @ObservedObject var model: Model
        var items: [Item]?

        var body: some View {
            HKParallaxCarousel(items ?? model.items, selection: $model.selection, cardHeight: 180,
                               cardWidthRatio: 0.8, spacing: 12) { item in
                LinearGradient(colors: [item.id == 1 ? .indigo : item.id == 2 ? .teal : .orange, .black],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                    .overlay { Image(systemName: "mountain.2.fill").resizable().scaledToFit().padding(32).foregroundStyle(.white.opacity(0.5)) }
            } overlay: { item in
                VStack(alignment: .leading) {
                    Text("Destination \(item.id)").font(.title2.bold())
                    Text("A stable foreground over a moving background").font(.caption)
                }
                .foregroundStyle(.white)
                .padding()
            }
            .frame(width: model.width)
        }
    }
}
#endif
