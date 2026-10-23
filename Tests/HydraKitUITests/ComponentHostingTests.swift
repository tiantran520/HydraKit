#if os(macOS)
import AppKit
import SwiftUI
import XCTest
@testable import HydraKitUI

/// Exercises real hosted SwiftUI controls without third-party view inspection.
final class ComponentHostingTests: XCTestCase {
    @MainActor private var windows: [NSWindow] = []
    @MainActor
    func testButtonActivationAndDisabledState() throws {
        var count = 0
        let ready = host(HKButton("Save") { count += 1 })
        let button = try element(in: ready, role: .button)
        XCTAssertTrue(button.isAccessibilityEnabled())
        XCTAssertTrue(button.accessibilityPerformPress())
        XCTAssertEqual(count, 1)

        let disabled = host(HKButton("Save") { count += 1 }.disabled(true))
        let disabledButton = try element(in: disabled, role: .button)
        XCTAssertFalse(disabledButton.isAccessibilityEnabled())
        _ = disabledButton.accessibilityPerformPress()
        XCTAssertEqual(count, 1)
    }

    @MainActor
    func testLoadingButtonIsDisabledAndDoesNotSubmit() throws {
        var count = 0
        let view = host(HKButton("Save", isLoading: true) { count += 1 })
        let button = try element(in: view, role: .button)
        XCTAssertFalse(button.isAccessibilityEnabled())
        _ = button.accessibilityPerformPress()
        XCTAssertEqual(count, 0)
    }

    @MainActor
    func testCheckboxActivationUpdatesParentBinding() throws {
        var selected = false
        let selection = Binding(get: { selected }, set: { selected = $0 })
        let view = host(HKCheckbox("Consent", isOn: selection))
        let checkbox = try element(in: view, role: .checkBox)
        XCTAssertTrue(checkbox.accessibilityPerformPress())
        XCTAssertTrue(selected)
    }

    @MainActor
    func testDisabledCheckboxPreservesParentBinding() throws {
        var selected = false
        let selection = Binding(get: { selected }, set: { selected = $0 })
        let view = host(HKCheckbox("Consent", isOn: selection).disabled(true))
        let checkbox = try element(in: view, role: .checkBox)
        XCTAssertFalse(checkbox.isAccessibilityEnabled())
        _ = checkbox.accessibilityPerformPress()
        XCTAssertFalse(selected)
    }

    @MainActor
    func testLongButtonAndCardContentGrowAtNarrowWidths() {
        let title = "A long localized action title that needs multiple lines to remain readable"
        let narrow = host(HKButton(title) {}, width: 180).fittingSize
        let wide = host(HKButton(title) {}, width: 600).fittingSize
        XCTAssertGreaterThan(narrow.height, wide.height)
        XCTAssertGreaterThanOrEqual(narrow.height, 44)
        XCTAssertLessThanOrEqual(narrow.width, 180)

        let card = host(HKCard { HKText(title) }, width: 180).fittingSize
        XCTAssertGreaterThan(card.height, 44)
        XCTAssertLessThanOrEqual(card.width, 180)
    }

    @MainActor
    func testOuterLineLimitStillControlsTextAndLabel() {
        let title = "A long localized title that needs several lines in a narrow container"
        let text = host(HKText(title), width: 140).fittingSize
        let limitedText = host(HKText(title).lineLimit(1), width: 140).fittingSize
        XCTAssertLessThan(limitedText.height, text.height)
        let label = host(HKLabel(title, systemImage: "info.circle"), width: 140).fittingSize
        let limitedLabel = host(HKLabel(title, systemImage: "info.circle").lineLimit(1), width: 140).fittingSize
        XCTAssertLessThan(limitedLabel.height, label.height)
    }

    @MainActor
    func testNativePrimaryButtonStyleReadsInjectedTheme() {
        let theme = DefaultTheme(controls: ControlTokens(mediumHeight: 90))
        let view = host(Button("Save") {}.buttonStyle(.hkPrimary).ironBitTheme(theme))
        XCTAssertGreaterThanOrEqual(view.fittingSize.height, 90)
    }

    @MainActor
    func testLegacyLabelStyleModifierRemainsEffective() {
        let native = host(Label("A title that must be hidden", systemImage: "star").labelStyle(.iconOnly).font(TypographyTokens().body), width: nil).fittingSize
        let wrapped = host(HKLabel("A title that must be hidden", systemImage: "star").labelStyle(.iconOnly), width: nil).fittingSize
        XCTAssertEqual(wrapped.height, native.height, accuracy: 1)
        XCTAssertEqual(wrapped.width, native.width, accuracy: 1)
        // A title-only layout should no longer reserve space for the symbol.
        let expected = host(Label("A title that wraps across lines", systemImage: "star").labelStyle(.titleOnly).font(TypographyTokens().body), width: 110).fittingSize
        let actual = host(HKLabel("A title that wraps across lines", systemImage: "star").labelStyle(.titleOnly).font(TypographyTokens().body), width: 110).fittingSize
        XCTAssertEqual(actual.height, expected.height, accuracy: 1)
    }

    @MainActor
    func testLegacyButtonKeepsItsMinimumHeight() {
        XCTAssertEqual(host(HKButton("Save") {}).fittingSize.height, 44, accuracy: 0.5)
        XCTAssertEqual(host(Button("Save") {}.buttonStyle(.hkPrimary)).fittingSize.height, 44, accuracy: 0.5)
    }

    @MainActor
    func testFillImageStaysInsideParentBounds() throws {
        let source = NSImage(size: NSSize(width: 200, height: 50), flipped: false) { rect in
            NSColor.green.setFill()
            rect.fill()
            return true
        }
        let content = HKImage(Image(nsImage: source), variant: .rectangle)
            .frame(width: 100, height: 100)
            .padding(50)
            .background(Color.blue)
        let image = try XCTUnwrap(ImageRenderer(content: content).cgImage)
        let bitmap = NSBitmapImageRep(cgImage: image)
        let outside = try XCTUnwrap(bitmap.colorAt(x: 10, y: 100)?.usingColorSpace(.sRGB))
        XCTAssertGreaterThan(outside.blueComponent, outside.greenComponent)
    }

    @MainActor
    func testNilImageURLPreservesLegacyPlaceholderWithoutNetwork() throws {
        let view = HKAsyncImage(url: nil) {
            Color.red.frame(width: 40, height: 40)
        } failure: {
            Color.green.frame(width: 40, height: 40)
        }
        let image = try XCTUnwrap(ImageRenderer(content: view).cgImage)
        let bitmap = NSBitmapImageRep(cgImage: image)
        let pixel = try XCTUnwrap(bitmap.colorAt(x: 20, y: 20)?.usingColorSpace(.sRGB))
        XCTAssertGreaterThan(pixel.redComponent, pixel.greenComponent)
    }

    @MainActor
    func testTextFieldEditingWritesParentBinding() throws {
        var text = "Before"
        let binding = Binding(get: { text }, set: { text = $0 })
        let view = host(HKTextField("Name", text: binding))
        let field = try XCTUnwrap(nativeTextFields(in: view).first)
        field.stringValue = "After"
        field.delegate?.controlTextDidChange?(Notification(name: NSControl.textDidChangeNotification, object: field))
        XCTAssertEqual(text, "After")
    }

    @MainActor
    func testSecureFieldUsesNativeSecureControlAndHonorsDisabled() throws {
        let view = host(HKSecureField("Password", text: .constant("secret")).disabled(true))
        let field = try XCTUnwrap(nativeTextFields(in: view).first as? NSSecureTextField)
        XCTAssertFalse(field.isEnabled)
    }

    @MainActor
    func testLegacyImageKeepsSuppliedTemplateRenderingMode() throws {
        let source = NSImage(size: NSSize(width: 40, height: 40), flipped: false) { rect in
            NSColor.green.setFill()
            rect.fill()
            return true
        }
        let view = HKImage(Image(nsImage: source).renderingMode(.template), variant: .rectangle)
            .foregroundStyle(.red)
            .frame(width: 40, height: 40)
        let image = try XCTUnwrap(ImageRenderer(content: view).cgImage)
        let bitmap = NSBitmapImageRep(cgImage: image)
        let pixel = try XCTUnwrap(bitmap.colorAt(x: 20, y: 20)?.usingColorSpace(.sRGB))
        XCTAssertGreaterThan(pixel.redComponent, pixel.greenComponent)
    }

    @MainActor
    func testFieldsDoNotAddNativeBordersInsideComponentOutline() throws {
        for style in [HKTextFieldStyle.standard, .floating, .stacked] {
            let plain = host(HKTextField("Legacy", text: .constant("Hydra"), style: style)
                .textFieldStyle(.roundedBorder))
            let secure = host(HKSecureField("Legacy", text: .constant("secret"), style: style)
                .textFieldStyle(.roundedBorder))
            for view in [AnyView(HKTextField("Legacy", text: .constant("Hydra"))),
                         AnyView(HKSecureField("Legacy", text: .constant("secret")))] where style == .standard {
                let legacy = host(view)
                let field = try XCTUnwrap(nativeTextFields(in: legacy).first)
                XCTAssertFalse(field.isBezeled, "Legacy initializer must have no inner bezel")
                XCTAssertFalse(field.isBordered, "Legacy initializer must have no inner border")
            }
            for field in [try XCTUnwrap(nativeTextFields(in: plain).first),
                          try XCTUnwrap(nativeTextFields(in: secure).first)] {
                XCTAssertFalse(field.isBezeled, "Only the component outline should be drawn")
                XCTAssertFalse(field.isBordered, "Ancestor styles must not add a second border")
            }
        }
    }

    @MainActor
    func testStyledFieldsKeepNativeBindingsAndSecureInput() throws {
        for style in [HKTextFieldStyle.floating, .stacked] {
            var text = "Before"
            let binding = Binding(get: { text }, set: { text = $0 })
            let plain = host(HKTextField("Name", text: binding, style: style))
            let field = try XCTUnwrap(nativeTextFields(in: plain).first)
            field.stringValue = "After"
            field.delegate?.controlTextDidChange?(Notification(name: NSControl.textDidChangeNotification, object: field))
            XCTAssertEqual(text, "After")
            let secure = host(HKSecureField("Password", text: binding, style: style).disabled(true))
            let secureField = try XCTUnwrap(nativeTextFields(in: secure).first as? NSSecureTextField)
            XCTAssertFalse(secureField.isEnabled)
        }
    }

    @MainActor
    func testStyledFieldsWrapLongLabelsAndErrors() throws {
        for style in [HKTextFieldStyle.floating, .stacked] {
            let short = host(HKTextField("Name", text: .constant(""), style: style), width: 180).fittingSize
            let long = host(HKTextField("A long localized label that should remain fully readable", text: .constant(""),
                                       state: .error("A long error explains how to correct the value without clipping."), style: style), width: 180).fittingSize
            XCTAssertGreaterThan(long.height, short.height)
            XCTAssertLessThanOrEqual(long.width, 180)
        }
        try renderFieldGalleryWhenRequested()
    }

    @MainActor
    func testFloatingTitleDoesNotShiftFieldHeightOnFocus() {
        func measured(_ focused: Bool) -> NSSize {
            host(HKFieldContainer(title: Text("Email"), style: .floating, state: .normal,
                                  isFocused: focused, hasText: false) { Text(" ") }).fittingSize
        }
        XCTAssertEqual(measured(false).height, measured(true).height, accuracy: 0.5)
    }

    @MainActor
    func testSwitchThumbFollowsBindingAndLayoutDirection() throws {
        for direction in [LayoutDirection.leftToRight, .rightToLeft] {
            for selected in [false, true] {
                let view = HKSwitch("Enabled", isOn: .constant(selected), variant: .thumbIcon,
                                    on: .init(background: .black), off: .init(background: .black), thumbColor: .white)
                    .environment(\.layoutDirection, direction)
                let image = try XCTUnwrap(ImageRenderer(content: view).cgImage)
                let bitmap = NSBitmapImageRep(cgImage: image)
                let left = try XCTUnwrap(bitmap.colorAt(x: image.width / 4, y: image.height / 2)?.usingColorSpace(.sRGB))
                let right = try XCTUnwrap(bitmap.colorAt(x: image.width * 3 / 4, y: image.height / 2)?.usingColorSpace(.sRGB))
                let shouldBeRight = selected == (direction == .leftToRight)
                XCTAssertGreaterThan(shouldBeRight ? right.redComponent : left.redComponent,
                                     shouldBeRight ? left.redComponent : right.redComponent)
            }
        }
    }

    @MainActor
    func testSwitchLongTitlesGrowWithoutClipping() throws {
        let short = host(HKSwitch("Enabled", isOn: .constant(true), variant: .labeled), width: 180).fittingSize
        let long = host(HKSwitch("Enabled", isOn: .constant(true), variant: .labeled,
                                on: .init(title: Text("A long translated switch title that must remain readable"))), width: 180).fittingSize
        XCTAssertGreaterThan(long.height, short.height)
        try renderSwitchGalleryWhenRequested()
    }

    @MainActor
    func testSwitchFitsNarrowContainerAndKeepsMinimumTargetAtSmallTextSize() throws {
        let small = host(HKSwitch("Enabled", isOn: .constant(true))
            .environment(\.dynamicTypeSize, .xSmall), width: nil).fittingSize
        XCTAssertGreaterThanOrEqual(small.height, 44)
        let control = HKSwitch("Enabled", isOn: .constant(true), variant: .labeled,
                               on: .init(background: .black), thumbColor: .white)
            .frame(width: 110)
            .padding(30)
            .background(Color.red)
        let image = try XCTUnwrap(ImageRenderer(content: control).cgImage)
        let bitmap = NSBitmapImageRep(cgImage: image)
        let outside = try XCTUnwrap(bitmap.colorAt(x: 25, y: image.height / 2)?.usingColorSpace(.sRGB))
        XCTAssertGreaterThan(outside.redComponent, 0.9, "Track must stay inside the parent frame")
    }

    @MainActor
    func testSwitchPreservesNativeToggleAccessibilityAndDisabledState() throws {
        var selected = false
        let view = host(HKSwitch("Appearance", isOn: Binding(get: { selected }, set: { selected = $0 })).disabled(true))
        let toggle = try element(in: view, role: .checkBox)
        XCTAssertFalse(toggle.isAccessibilityEnabled())
        _ = toggle.accessibilityPerformPress()
        XCTAssertFalse(selected)
    }

    @MainActor
    private func renderSwitchGalleryWhenRequested() throws {
        guard let output = ProcessInfo.processInfo.environment["HYDRAKIT_PREVIEW_OUTPUT"] else { return }
        for scheme in [ColorScheme.light, .dark] {
            let gallery = VStack(alignment: .leading, spacing: 24) {
                HKText("Switch variants", variant: .title)
                ForEach([HKSwitch.HKVariant.labeled, .trackIcon, .thumbIcon], id: \.self) { variant in
                    HStack(spacing: 24) {
                        HKSwitch("Day appearance", isOn: .constant(true), variant: variant, size: .lg,
                                 on: .init(title: Text("DAY MODE"), systemImage: "sun.max", background: .orange, foreground: .white),
                                 thumbColor: .white, thumbForeground: .black)
                        HKSwitch("Night appearance", isOn: .constant(false), variant: variant, size: .lg,
                                 off: .init(title: Text("NIGHT MODE"), systemImage: "moon.fill", background: .indigo, foreground: .white),
                                 thumbColor: .white, thumbForeground: .black)
                    }
                }
                HKSwitch("Disabled", isOn: .constant(true)).disabled(true)
                HKSwitch("A long setting", isOn: .constant(true), variant: .labeled,
                         on: .init(title: Text("A long localized state title that remains readable at larger text sizes"), systemImage: "checkmark"))
                    .environment(\.dynamicTypeSize, .accessibility3)
            }
            .padding(24)
            .background(scheme.defaultHydraTheme.colors.background)
            .ironBitTheme(scheme.defaultHydraTheme)
            .environment(\.colorScheme, scheme)
            let image = try XCTUnwrap(ImageRenderer(content: gallery.frame(width: 600, alignment: .leading)
                .background(scheme.defaultHydraTheme.colors.background)).cgImage)
            let bitmap = NSBitmapImageRep(cgImage: image)
            let data = try XCTUnwrap(bitmap.representation(using: .png, properties: [:]))
            try data.write(to: URL(fileURLWithPath: output).appendingPathComponent("switches-\(scheme == .light ? "light" : "dark").png"))
        }
    }

    @MainActor
    private func renderFieldGalleryWhenRequested() throws {
        guard let output = ProcessInfo.processInfo.environment["HYDRAKIT_PREVIEW_OUTPUT"] else { return }
        for scheme in [ColorScheme.light, .dark] {
            let gallery = VStack(alignment: .leading, spacing: 24) {
                HKText("Legacy, floating and stacked inputs", variant: .title)
                HKTextField("Legacy", text: .constant("Email"))
                HKSecureField("Legacy", text: .constant("secret"))
                HKTextField("Email", text: .constant(""), style: .floating)
                HKTextField("Email", text: .constant("simeon@gmail.com"), style: .floating)
                HKTextField("Email", text: .constant("simeon@gmail.com"), style: .stacked)
                HKSecureField("Password", text: .constant("123"), state: .error("Enter a valid password"), style: .stacked)
                HKSecureField("Password", text: .constant("123"), state: .error("Enter a valid password"), style: .floating)
                HKButton("Log In") {}.disabled(true)
            }
            .padding(24)
            .background(scheme.defaultHydraTheme.colors.surface)
            .ironBitTheme(scheme.defaultHydraTheme)
            .environment(\.colorScheme, scheme)
            let view = host(gallery, width: 430)
            view.setFrameSize(view.fittingSize)
            view.layoutSubtreeIfNeeded()
            let bitmap = try XCTUnwrap(view.bitmapImageRepForCachingDisplay(in: view.bounds))
            view.cacheDisplay(in: view.bounds, to: bitmap)
            let data = try XCTUnwrap(bitmap.representation(using: .png, properties: [:]))
            try data.write(to: URL(fileURLWithPath: output).appendingPathComponent("fields-\(scheme == .light ? "light" : "dark").png"))
        }
    }

    @MainActor
    private func nativeTextFields(in view: NSView) -> [NSTextField] {
        (view as? NSTextField).map { [$0] } ?? view.subviews.flatMap { nativeTextFields(in: $0) }
    }

    @MainActor
    private func element(in view: NSView, role: NSAccessibility.Role) throws -> NSAccessibilityProtocol {
        let calibration = host(Button("Accessibility bridge probe") {})
        let calibrationNodes = elements(in: calibration)
        try XCTSkipUnless(calibrationNodes.contains { $0.accessibilityRole() == .button },
                          "Native Button has no AX element in the SwiftPM runner; requires an app-hosted test target.")
        let nodes = elements(in: view)
        return try XCTUnwrap(nodes.first { $0.accessibilityRole() == role })
    }

    @MainActor
    private func host<V: View>(_ view: V, width: CGFloat? = 320) -> NSHostingView<some View> {
        _ = NSApplication.shared
        let host = NSHostingView(rootView: view.frame(width: width))
        host.frame = NSRect(x: 0, y: 0, width: width ?? 320, height: 1000)
        let window = NSWindow(contentRect: host.frame, styleMask: [.borderless], backing: .buffered, defer: false)
        window.contentView = host
        windows.append(window)
        host.layoutSubtreeIfNeeded()
        window.displayIfNeeded()
        return host
    }

    @MainActor
    private func elements(in object: Any, depth: Int = 0) -> [NSAccessibilityProtocol] {
        guard depth < 20, let node = object as? NSAccessibilityProtocol else { return [] }
        return [node] + (node.accessibilityChildren() ?? []).flatMap { elements(in: $0, depth: depth + 1) }
    }
}
#endif
