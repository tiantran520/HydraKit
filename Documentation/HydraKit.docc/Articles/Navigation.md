# HydraKitNavigation: hướng dẫn sử dụng

Router giữ trạng thái điều hướng; SwiftUI view chịu trách nhiệm dựng NavigationStack, sheet và destination. Coordinator tổ chức flow và vòng đời.

## Gắn router với SwiftUI

```swift
import SwiftUI
import HydraKitNavigation

struct DetailRoute: Route {
    let id: Int
    var routeIdentifier: RouteIdentifier { "detail" }
}

@MainActor
struct NavigationDemo: View {
    @StateObject private var router = HKNavigationRouter()

    var body: some View {
        NavigationStack(path: Binding(
            get: { router.path },
            set: { router.setPath($0) }
        )) {
            Button("Mở chi tiết") { router.push(DetailRoute(id: 1)) }
                .navigationDestination(for: AnyRoute.self) { route in
                    if let detail = route.route(as: DetailRoute.self) {
                        Text("Chi tiết #\(detail.id)")
                    }
                }
        }
    }
}
```

`path` là private(set), vì vậy không truyền `$router.path` trực tiếp; dùng Binding với `setPath`. `pop()` bỏ route cuối, `popToRoot()` xóa stack. Route conform Hashable & Sendable, identifier dùng để chọn loại destination; dữ liệu như ID nằm trong route.

## Registry và modal

`HKRouteRegistry.register(_:identifier:builder:)` map type và identifier sang AnyView. Dùng `registry.destination(for:)` trong navigationDestination. Identifier không được đăng ký hoặc sai type trả EmptyView: nếu màn hình trống, kiểm tra hai giá trị này trước.

`router.present(route)` cập nhật presentedRoute; app tự gắn `.sheet(item:)` với Binding getter/setter (setter nil gọi dismiss). `HKSheetCoordinator` tương tự và giữ thêm presentation sheet/fullScreen/popover; nó không tự chọn modifier SwiftUI hoặc hiển thị modal.

## Coordinator

Subclass `HKBaseCoordinator`, override `start()` và gọi `super.start()` trước khi push route đầu. Khi tạo flow con, `addChild(child)` giữ owner rồi gọi `child.start()`; khi kết thúc gọi stop/removeChild. `stop()` dừng và giải phóng children, không tự reset router hoặc dismiss màn hình.

## Deep link

```swift
@MainActor
func openDetail(router: HKNavigationRouter) -> Bool {
    let handler = HKDeepLinkHandler(router: router) { link in
        guard link.routeIdentifier == RouteIdentifier("detail"),
              let text = link.parameters["id"], let id = Int(text) else { return nil }
        return AnyRoute(DetailRoute(id: id))
    }
    return handler.handle(URL(string: "myapp://detail?id=42")!)
}
```

Import Foundation nếu file chưa import SwiftUI. Giữ handler trong owner và gọi từ `.onOpenURL`. Parser mặc định dùng path đã trim `/`; nếu path rỗng thì dùng host. `myapp://detail?id=42` map thành detail, còn `myapp://detail/42` map thành 42. App tự cấu hình URL scheme/universal links và xác thực scheme, host, quyền truy cập trước khi push.

Parser dùng Dictionary với key duy nhất; query có tên trùng có thể gây trap. Dùng parser riêng khi cần xử lý URL ngoài có query trùng hoặc quy tắc path khác.

## Tab và flow

### Tab: chọn màn hình chính bằng HKTabCoordinator

`TabRoute` mở rộng Route với `title` và `systemImage`. Enum phù hợp cho danh sách tab cố định; mỗi case cần identifier riêng. `HKTabCoordinator` giữ danh sách và selection, còn TabView dựng nội dung.

Ví dụ hoàn chỉnh với hai tab và chuyển tab từ button:

```swift
import SwiftUI
import HydraKitNavigation

enum MainTab: String, CaseIterable, TabRoute {
    case home, settings

    var routeIdentifier: RouteIdentifier { RouteIdentifier(rawValue) }
    var title: String { self == .home ? "Trang chủ" : "Cài đặt" }
    var systemImage: String { self == .home ? "house" : "gearshape" }
}

@MainActor
struct MainTabsView: View {
    @StateObject private var tabs = HKTabCoordinator<MainTab>(
        tabs: MainTab.allCases,
        selection: .home
    )

    var body: some View {
        TabView(selection: $tabs.selection) {
            ForEach(tabs.tabs) { tab in
                tabContent(tab)
                    .tabItem { Label(tab.title, systemImage: tab.systemImage) }
                    .tag(tab)
            }
        }
    }

    @ViewBuilder
    private func tabContent(_ tab: MainTab) -> some View {
        switch tab {
        case .home:
            VStack {
                Text("Trang chủ")
                Button("Mở cài đặt") { tabs.select(.settings) }
            }
        case .settings:
            Text("Cài đặt")
        }
    }
}
```

`.tag(tab)` phải có cùng type với selection; tag là String trong khi selection là MainTab sẽ không chọn tab đúng. Dùng StateObject ở view sở hữu coordinator; view con nhận coordinator dùng ObservedObject hoặc truyền closure chuyển tab.

| API | Hành vi |
| --- | --- |
| `init(tabs:selection:)` | Bắt buộc tabs không rỗng; không truyền selection thì chọn tab đầu |
| `select(_:)` | Đổi selection nếu tab có trong tabs; tab vắng bị bỏ qua |
| `selection` | Published và ghi được trực tiếp, nên bind vào TabView được |
| `tabs` | Danh sách cố định sau khi khởi tạo |

Initializer và việc ghi trực tiếp selection không kiểm tra membership. Chọn initial selection thuộc tabs và ưu tiên `select` khi điều hướng bằng code. Không tạo coordinator mới trong body vì sẽ mất selection khi render lại.

### Giữ navigation riêng cho từng tab

Tab coordinator chỉ quản lý tab đang chọn, không quản lý stack bên trong tab. Nếu mỗi tab có màn hình chi tiết riêng, tạo một HKNavigationRouter cho mỗi tab trong owner sống cùng MainTabsView, rồi gắn mỗi router vào NavigationStack của tab đó. Dùng Binding get/setPath như ví dụ router phía trên.

Giữ router instance khi đổi tab để giữ stack. Nếu muốn tab luôn về root khi được chọn, chủ động gọi `popToRoot()` trên router tương ứng. Khi mở deep link đến detail của một tab, chọn tab trước rồi push vào đúng router; app tự kiểm tra quyền truy cập và dữ liệu route.

### Flow: điều khiển quy trình nhiều bước

`FlowStep` yêu cầu Hashable, Identifiable, Sendable và `route: AnyRoute`. Extension mặc định lấy id từ routeIdentifier; dùng identifier riêng cho từng bước để ForEach và registry nhận diện đúng.

Ví dụ onboarding hiển thị trực tiếp bước hiện tại, có nút quay lại, tiếp tục, hoàn thành và bắt đầu lại:

```swift
import SwiftUI
import HydraKitNavigation

enum OnboardingStep: String, CaseIterable, FlowStep {
    case welcome, profile, review

    var route: AnyRoute { AnyRoute(RouteIdentifier("onboarding.\(rawValue)")) }
}

@MainActor
struct OnboardingView: View {
    @StateObject private var flow = HKFlowCoordinator<OnboardingStep>(
        steps: OnboardingStep.allCases
    )
    @State private var name = ""
    @State private var completed = false

    var body: some View {
        VStack(spacing: 16) {
            if completed {
                Text("Đã hoàn thành")
                Button("Bắt đầu lại") {
                    name = ""
                    completed = false
                    flow.reset()
                }
            } else if let step = flow.currentStep {
                Text("Bước \(flow.currentIndex + 1)/\(flow.steps.count)")
                stepContent(step)
                HStack {
                    Button("Quay lại") { flow.previous() }
                        .disabled(flow.currentIndex == 0)
                    Button(step == .review ? "Hoàn thành" : "Tiếp tục") {
                        if step == .review {
                            completed = true
                        } else {
                            flow.next()
                        }
                    }
                    .disabled(step == .profile && name.trimmingCharacters(
                        in: .whitespacesAndNewlines
                    ).isEmpty)
                }
            } else {
                Text("Không có bước nào được cấu hình")
            }
        }
        .padding()
    }

    @ViewBuilder
    private func stepContent(_ step: OnboardingStep) -> some View {
        switch step {
        case .welcome:
            Text("Chào mừng bạn")
        case .profile:
            TextField("Tên của bạn", text: $name)
        case .review:
            Text("Xin chào, \(name)")
        }
    }
}
```

`completed` và dữ liệu form thuộc app, không nằm trong coordinator. Trong app thật, bước cuối có thể gọi use case async để lưu dữ liệu: khóa nút trong lúc lưu, chỉ hoàn thành khi thành công, hiển thị lỗi và giữ bước review nếu thất bại. Flow không tự validate, lưu dữ liệu hoặc hủy task.

### Các thao tác và giới hạn của flow

| API | Hành vi |
| --- | --- |
| `currentStep` | Bước theo currentIndex, hoặc nil nếu steps rỗng |
| `next()` | Tiến một bước; ở bước cuối giữ nguyên |
| `previous()` | Lùi một bước; ở bước đầu giữ nguyên |
| `go(to:)` | Tìm bước bằng equality, chuyển đến lần xuất hiện đầu; bỏ qua nếu không có |
| `reset()` | Đưa currentIndex về 0; không xóa dữ liệu form hoặc trạng thái hoàn thành |
| `init(steps:currentIndex:)` | Clamp chỉ mục vào phạm vi hợp lệ; mảng rỗng giữ chỉ mục 0 và currentStep nil |

`currentIndex` là Published private(set): observe được nhưng không bind để ghi trực tiếp. Dùng các method điều khiển. Coordinator chạy main actor; khi tác vụ background cần chuyển bước, quay về main actor.

`steps` cố định sau khi khởi tạo. Với nhánh tùy chọn, dựng danh sách phù hợp trước khi bắt đầu, hoặc dùng `go(to:)` để bỏ qua bước đã có. `next()` không tự skip theo điều kiện. Khi cần thay danh sách giữa flow, app phải dựng coordinator mới và quyết định cách giữ dữ liệu/chỉ mục.

### Hiển thị flow bằng registry hoặc router

Ví dụ trên switch theo currentStep nên không cần NavigationStack. Khi có HKRouteRegistry đã đăng ký các identifier `onboarding.welcome`, `onboarding.profile`, `onboarding.review`, có thể render `registry.destination(for: step.route)` thay cho switch.

`AnyRoute(RouteIdentifier(...))` trong ví dụ chỉ chứa identifier, không chứa typed Route. Vì vậy dùng overload `register(identifier:builder:)` cho registry; nếu dùng `register(SomeRoute.self, ...)`, hãy để FlowStep.route bọc instance SomeRoute thật.

HKFlowCoordinator không tự cập nhật HKNavigationRouter. Nếu chọn NavigationStack cho flow, app phải đồng bộ bước và router theo một quy tắc rõ ràng. Không push lại route mỗi lần body render; chỉ cập nhật khi bước đổi. Khi cho phép nút Back hoặc gesture của NavigationStack, đồng bộ việc pop về currentIndex để tránh router hiện một bước nhưng coordinator giữ bước khác.

### Lưu tiến độ và kiểm thử

Muốn resume sau khi đóng app, lưu identifier bước và dữ liệu form qua Storage của app. Khi mở lại, tìm vị trí bước trong danh sách hiện tại rồi truyền currentIndex; nếu bước đã bị bỏ ở version mới, chọn bước khởi đầu phù hợp. Chỉ lưu chỉ mục có thể đưa người dùng đến sai bước khi thứ tự thay đổi.

Kiểm tra tab đầu mặc định, select tab hợp lệ và select tab không có. Với flow, kiểm tra next/previous ở biên, go đến bước có/vắng, reset và flow rỗng. Kiểm tra thêm hành vi của app: dữ liệu vẫn còn khi quay lại, validation chặn tiến bước, và thao tác hoàn thành chỉ chạy một lần khi lưu thành công.
