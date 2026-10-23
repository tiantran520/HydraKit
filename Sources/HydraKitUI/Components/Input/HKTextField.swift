import SwiftUI

/// A native text field. The parent owns its text and validation; focus can be shared.
public struct HKTextField: View {
    /// Validation feedback; independent of editing/focus and disabled state.
    public enum State: Sendable, Equatable {
        case normal
        case success
        case error(String?)

        /// Parent-provided validation feedback, or nil when no message is available.
        public var errorMessage: String? {
            if case let .error(message) = self { return message }
            return nil
        }
    }

    @Binding private var text: String
    @FocusState private var internalFocus: Bool
    private let title: Text
    private let style: HKTextFieldStyle
    private let prompt: Text?
    private let state: State
    private let focus: FocusState<Bool>.Binding?

    /// Creates a field. Defaults: normal validation, title as prompt, internally managed focus.
    /// Apply native keyboardType/textContentType/autocorrectionDisabled/onSubmit modifiers as needed.
    /// Preserves the original initializer and parent-owned validation.
    public init(_ title: String, text: Binding<String>, state: State = .normal) {
        self.init(Text(title), text: text, state: state)
    }

    /// Creates a field with optional validation, prompt, and shared focus.
    public init(
        _ title: String, text: Binding<String>, state: State = .normal,
        prompt: Text? = nil, focus: FocusState<Bool>.Binding? = nil
    ) {
        self.init(Text(title), text: text, state: state, prompt: prompt, focus: focus)
    }

    /// Creates a field with a visible label style. Old initializers retain the standard layout.
    public init(
        _ title: String, text: Binding<String>, state: State = .normal,
        style: HKTextFieldStyle, prompt: Text? = nil, focus: FocusState<Bool>.Binding? = nil
    ) {
        self.init(Text(title), text: text, state: state, style: style, prompt: prompt, focus: focus)
    }

    /// Preserves the localized-label initializer and its original factory signature.
    public init(
        _ title: Text, text: Binding<String>, state: State = .normal,
        prompt: Text? = nil, focus: FocusState<Bool>.Binding? = nil
    ) {
        self.init(title, text: text, state: state, style: .standard, prompt: prompt, focus: focus)
    }

    /// Creates localized input with a floating or stacked title.
    public init(
        _ title: Text, text: Binding<String>, state: State = .normal,
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
            TextField(text: $text, prompt: prompt ?? title) { title }
        } else {
            // The custom title is visual; a stable native accessibility label remains on the input.
            TextField(text: $text, prompt: nativePrompt) { Text("") }
                .accessibilityLabel(title)
        }
    }

    private var nativePrompt: Text? {
        let presentation = HKFieldPresentation(style: style, isFocused: isFocused, hasText: !text.isEmpty)
        return style == .floating && !presentation.isLabelFloating ? nil : prompt
    }
}

#Preview("HKTextField: standard, floating and stacked") {
    @Previewable @State var value = ""
    @Previewable @FocusState var focused: Bool
    HKComponentPreview {
        HKTextField("Legacy", text: $value)
        HKTextField("Email", text: $value, style: .floating, focus: $focused)
        HKTextField("Filled", text: .constant("hello@hydra.dev"), style: .floating)
        HKTextField("Password", text: .constant("secret"), state: .error("Enter a valid password"), style: .stacked)
        HKTextField("Disabled", text: .constant(""), style: .stacked).disabled(true)
        HKTextField("A long localized field label that can wrap at larger text sizes", text: $value, style: .floating)
        Button("Focus floating input") { focused = true }
    }
}
