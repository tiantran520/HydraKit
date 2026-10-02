#if DEBUG
#if canImport(SwiftUI)
import SwiftUI

/// A SwiftUI screen for running developer-only actions.
public struct DevMenuView: View {
    private let title: String
    private let sections: [DevMenuSection]

    /// Creates a developer menu view.
    /// - Parameters:
    ///   - title: The navigation title.
    ///   - sections: The sections to display.
    public init(
        title: String = "Developer Menu",
        sections: [DevMenuSection]
    ) {
        self.title = title
        self.sections = sections
    }

    /// The menu body.
    public var body: some View {
        List {
            ForEach(sections) { section in
                Section(section.title) {
                    ForEach(section.actions) { action in
                        Button(role: action.isDestructive ? .destructive : nil) {
                            action.perform()
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(action.title)

                                if let subtitle = action.subtitle {
                                    Text(subtitle)
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(title)
    }
}
#endif
#endif
