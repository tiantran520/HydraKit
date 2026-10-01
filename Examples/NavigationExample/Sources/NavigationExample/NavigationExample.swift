import IronBitCoreKitNavigation
import IronBitCoreKitUI
import SwiftUI

struct DetailsRoute: Route {
    let routeIdentifier: RouteIdentifier = "details"
    let title: String
}

@main
struct NavigationExample: App {
    var body: some Scene {
        WindowGroup {
            NavigationContentView()
                .ironBitTheme(DefaultTheme())
        }
    }
}

struct NavigationContentView: View {
    @StateObject private var router = NavigationRouter()

    var body: some View {
        VStack(spacing: 16) {
            IBText("Navigation Example", variant: .title)

            IBButton("Push Details") {
                // Coordinator thật thường gọi router.push(...) từ ViewModel hoặc flow object.
                router.push(DetailsRoute(title: "Chi tiết"))
            }

            IBButton("Pop", variant: .secondary) {
                router.pop()
            }

            IBCard {
                VStack(alignment: .leading) {
                    IBText("Current path", variant: .headline)
                    Text(router.path.map(\.routeIdentifier.rawValue).joined(separator: " > "))
                        .font(.caption)
                }
            }
        }
        .padding(24)
        .frame(minWidth: 420, minHeight: 300)
    }
}
