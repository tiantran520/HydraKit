import HydraKitNavigation
import HydraKitUI
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
    @StateObject private var router = HKNavigationRouter()

    var body: some View {
        VStack(spacing: 16) {
            HKText("Navigation Example", variant: .title)

            HKButton("Push Details") {
                // Coordinator thật thường gọi router.push(...) từ ViewModel hoặc flow object.
                router.push(DetailsRoute(title: "Chi tiết"))
            }

            HKButton("Pop", variant: .secondary) {
                router.pop()
            }

            HKCard {
                VStack(alignment: .leading) {
                    HKText("Current path", variant: .headline)
                    Text(router.path.map(\.routeIdentifier.rawValue).joined(separator: " > "))
                        .font(.caption)
                }
            }
        }
        .padding(24)
        .frame(minWidth: 420, minHeight: 300)
    }
}
