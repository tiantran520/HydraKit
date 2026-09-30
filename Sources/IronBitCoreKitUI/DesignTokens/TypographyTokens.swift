import SwiftUI

/// Typography tokens used by reusable UI components.
public struct TypographyTokens: Sendable {
    /// Large display font.
    public let display: Font
    /// Page title font.
    public let title: Font
    /// Section headline font.
    public let headline: Font
    /// Body font.
    public let body: Font
    /// Secondary body font.
    public let callout: Font
    /// Caption font.
    public let caption: Font
    /// Button label font.
    public let button: Font

    /// Creates typography tokens.
    public init(
        display: Font = .largeTitle.weight(.bold),
        title: Font = .title2.weight(.semibold),
        headline: Font = .headline,
        body: Font = .body,
        callout: Font = .callout,
        caption: Font = .caption,
        button: Font = .body.weight(.semibold)
    ) {
        self.display = display
        self.title = title
        self.headline = headline
        self.body = body
        self.callout = callout
        self.caption = caption
        self.button = button
    }
}
