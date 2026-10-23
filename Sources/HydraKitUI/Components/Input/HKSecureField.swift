import SwiftUI

/// Native secure input with the same validation and focus appearance as HKTextField.
public struct HKSecureField: View {
    @Binding private var text: String
    @FocusState private var internalFocus: Bool
    private let title: Text
    private let style: HKTextFieldStyle
    private let prompt: Text?
    private let state: HKTextField.State
    private let focus: FocusState<Bool>.Binding?

    /// Defaults: normal validation, title as prompt, internally managed focus.
    /// Text and validation are controlled by the parent; password contents are never spoken as feedback.
    /// Preserves the original secure-field initializer.
    public init(_ title: String, text: Binding<String>) {
        self.init(Text(title), text: text)
    }

    /// Creates secure input with optional validation, prompt, and shared focus.
    public init(
        _ title: String, text: Binding<String>, state: HKTextField.State = .normal,
        prompt: Text? = nil, focus: FocusState<Bool>.Binding? = nil
    ) {
        self.init(Text(title), text: text, state: state, prompt: prompt, focus: focus)
    }

    /// Creates a field with a visible label style. Old initializers retain the standard layout.
    public init(
        _ title: String, text: Binding<String>, state: HKTextField.State = .normal,
        style: HKTextFieldStyle, prompt: Text? = nil, focus: FocusState<Bool>.Binding? = nil
    ) {
        self.init(Text(title), text: text, state: state, style: style, prompt: prompt, focus: focus)
    }

    /// Preserves the localized-label initializer and its original factory signature.
    public init(
        _ title: Text, text: Binding<String>, state: HKTextField.State = .normal,
        prompt: Text? = nil, focus: FocusState<Bool>.Binding? = nil
    ) {
        self.init(title, text: text, state: state, style: .standard, prompt: prompt, focus: focus)
    }

    /// Creates localized input with a floating or stacked title.
    public init(
        _ title: Text, text: Binding<String>, state: HKTextField.State = .normal,
        style: HKTextFieldStyle, prompt: Text? = nil, focus: FocusState<Bool>.Binding? = nil
    ) {
        self.title = title
        self._text = text
        self.state = state
        self.style = style
        self.prompt = prompt
        self.focus = focus
    }

    public var body: some View {
        HKFieldContainer(title: title, style: style, state: state,
                         isFocused: isFocused, hasText: !text.isEmpty) {
            input
                // The component draws its own outline; native styles must not add an inner bezel.
                .textFieldStyle(.plain)
                .focused(focus ?? $internalFocus)
                .hkOptionalAccessibilityHint(state.errorMessage.map { Text($0) })
        }
    }

    private var isFocused: Bool { focus?.wrappedValue ?? internalFocus }

    @ViewBuilder private var input: some View {
        if style == .standard {
            SecureField(text: $text, prompt: prompt ?? title) { title }
        } else {
            // The custom title is visual; a stable native accessibility label remains on the input.
            SecureField(text: $text, prompt: nativePrompt) { Text("") }
                .accessibilityLabel(title)
        }
    }

    private var nativePrompt: Text? {
        let presentation = HKFieldPresentation(style: style, isFocused: isFocused, hasText: !text.isEmpty)
        return style == .floating && !presentation.isLabelFloating ? nil : prompt
    }
}

#Preview("HKSecureField: standard, floating and stacked") {
    @Previewable @State var value = ""
    @Previewable @FocusState var focused: Bool
    HKComponentPreview {
        HKSecureField("Legacy", text: $value)
        HKSecureField("Email", text: $value, style: .floating, focus: $focused)
        HKSecureField("Filled", text: .constant("hello@hydra.dev"), style: .floating)
        HKSecureField("Password", text: .constant("secret"), state: .error("Enter a valid password"), style: .stacked)
        HKSecureField("Disabled", text: .constant(""), style: .stacked).disabled(true)
        HKSecureField("A long localized field label that can wrap at larger text sizes", text: $value, style: .floating)
        Button("Focus floating input") { focused = true }
    }
}
