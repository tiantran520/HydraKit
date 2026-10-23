import SwiftUI
import XCTest
import HydraKitUI

/// Public-import checks: existing clients must not need @testable or new arguments.
final class LegacyCompatibilityTests: XCTestCase {
    @MainActor
    func testOriginalInitializerReferencesStillCompile() {
        // Default arguments do not preserve the type of an initializer used as a factory.
        let text: (String, HKText.HKVariant) -> HKText = HKText.init
        let label: (String, String) -> HKLabel = HKLabel.init
        let field: (String, Binding<String>, HKTextField.State) -> HKTextField = HKTextField.init
        let secure: (String, Binding<String>) -> HKSecureField = HKSecureField.init
        let toggle: (String, Binding<Bool>, HKToggle.HKVariant) -> HKToggle = HKToggle.init
        let checkbox: (String, Binding<Bool>) -> HKCheckbox = HKCheckbox.init
        let icon: (String, HKIcon.HKSize) -> HKIcon = HKIcon.init
        let image: (Image, HKImage.HKVariant) -> HKImage = HKImage.init
        let button: (String, HKButton<Text>.HKVariant, @escaping @MainActor () -> Void) -> HKButton<Text> = HKButton<Text>.init
        let customButton: (HKButton<Text>.HKVariant, @escaping @MainActor () -> Void, () -> Text) -> HKButton<Text> = HKButton<Text>.init
        let card: (HKCard<Text>.HKVariant, () -> Text) -> HKCard<Text> = HKCard<Text>.init
        let asyncImage: (URL?) -> HKAsyncImage<SkeletonView, Image> = HKAsyncImage.init
        let customAsyncImage: (URL?, () -> Text, () -> Text) -> HKAsyncImage<Text, Text> = HKAsyncImage.init

        _ = text("Body", .body)
        _ = label("Name", "person")
        _ = field("Name", .constant("Hydra"), .normal)
        _ = secure("Password", .constant("secret"))
        _ = toggle("Notifications", .constant(true), .standard)
        _ = checkbox("Consent", .constant(false))
        _ = icon("star", .md)
        _ = image(Image(systemName: "photo"), .rounded)
        _ = button("Save", .primary, {})
        _ = customButton(.secondary, {}, { Text("Save") })
        _ = card(.outlined, { Text("Card") })
        _ = asyncImage(nil)
        _ = customAsyncImage(nil, { Text("Loading") }, { Text("Failure") })
    }

    func testOriginalThemeAndColorFactoriesStillCompile() {
        let theme: (ColorTokens, TypographyTokens, SpacingTokens, RadiusTokens, ShadowTokens, AnimationTokens) -> DefaultTheme = DefaultTheme.init
        let colors: (Color, Color, Color, Color, Color, Color, Color, Color, Color, Color, Color) -> ColorTokens = ColorTokens.init
        let palette = colors(.blue, .gray, .teal, .white, .white, .primary, .secondary, .gray, .green, .orange, .red)
        _ = theme(palette, TypographyTokens(), SpacingTokens(), RadiusTokens(), ShadowTokens(), AnimationTokens())
    }

    @MainActor
    func testOriginalCallSyntaxAndCustomThemeStillCompile() {
        let views: [AnyView] = [
            AnyView(HKButton("Save") {}),
            AnyView(HKButton(variant: .secondary, action: {}) { Text("Save") }),
            AnyView(HKText("Title", variant: .title)),
            AnyView(HKLabel("Profile", systemImage: "person").labelStyle(.titleOnly)),
            AnyView(HKTextField("Name", text: .constant(""), state: .error("Required"))),
            AnyView(HKSecureField("Password", text: .constant(""))),
            AnyView(HKToggle("Notifications", isOn: .constant(true), variant: .compact)),
            AnyView(HKCheckbox("Consent", isOn: .constant(true))),
            AnyView(HKImage(Image(systemName: "photo")).accessibilityLabel(Text("Photo"))),
            AnyView(HKIcon("star", size: .lg).accessibilityLabel(Text("Favorite"))),
            AnyView(HKCard(variant: .elevated) { Text("Card") }),
            AnyView(HKAsyncImage(url: nil)),
            AnyView(HKAsyncImage(url: nil) { Text("Loading") } failure: { Text("Retry") })
        ]
        for view in views { _ = view.ironBitTheme(LegacyTheme()) }
        let theme: any Theme = LegacyTheme()
        XCTAssertGreaterThanOrEqual(theme.controls.minimumTarget, 44)
    }
}

/// An unchanged Theme conformance from before ControlTokens existed.
private struct LegacyTheme: Theme {
    let colors = ColorTokens()
    let typography = TypographyTokens()
    let spacing = SpacingTokens()
    let radius = RadiusTokens()
    let shadows = ShadowTokens()
    let animations = AnimationTokens()
}
