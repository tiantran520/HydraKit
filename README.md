# IronBitCoreKit

IronBitCoreKit là Swift Package đa nền tảng dành cho ứng dụng Apple, được thiết kế theo hướng module hóa, dễ kiểm thử và dễ mở rộng.

Package cung cấp các lớp nền tảng thường gặp trong một app hiện đại: core utilities, UI component library, navigation, networking, storage, domain, repository, MVVM, security, analytics, testing và dev tools.

## Yêu Cầu

- Swift 5.10
- iOS 17 trở lên
- macOS 14 trở lên
- watchOS 10 trở lên
- tvOS 17 trở lên
- visionOS 1 trở lên

## Cài Đặt

Repository:

```text
git@github.com:tiantran520/IronBitCoreKit.git
```

### Cài Bằng Xcode

1. Mở project trong Xcode.
2. Chọn `File` > `Add Package Dependencies...`.
3. Dán URL repository:

```text
git@github.com:tiantran520/IronBitCoreKit.git
```

4. Chọn dependency rule phù hợp. Trong giai đoạn đang phát triển, dùng `Branch` là `main`. Khi package đã có release tag ổn định, có thể dùng `Exact Version` hoặc `Up to Next Major Version`.
5. Chọn target app cần sử dụng package.
6. Tick các product cần add, ví dụ: `IronBitCoreKit`, `IronBitCoreKitUI`, `IronBitCoreKitNetwork`, `IronBitCoreKitNavigation`, `IronBitCoreKitStorage`.

Sau khi Xcode resolve xong, import module cần dùng trong source code.

### Cài Bằng Swift Package Manager

Nếu project của bạn là Swift package, thêm dependency vào `Package.swift`:

```swift
dependencies: [
    .package(url: "git@github.com:tiantran520/IronBitCoreKit.git", branch: "main")
]
```

Sau đó khai báo product cần dùng trong target:

```swift
.target(
    name: "MyApp",
    dependencies: [
        .product(name: "IronBitCoreKit", package: "IronBitCoreKit"),
        .product(name: "IronBitCoreKitUI", package: "IronBitCoreKit"),
        .product(name: "IronBitCoreKitNetwork", package: "IronBitCoreKit")
    ]
)
```

### Chọn Product Theo Nhu Cầu

Bạn không cần add toàn bộ package nếu app chỉ dùng một phần. Nên chọn module theo tính năng:

- Dùng utilities, logging, DI: `IronBitCoreKit`
- Dùng SwiftUI component/theme: `IronBitCoreKitUI`
- Dùng API client/cache/interceptor: `IronBitCoreKitNetwork`
- Dùng coordinator/router/deep link: `IronBitCoreKitNavigation`
- Dùng UserDefaults/Keychain/File/CoreData/SwiftData/cache: `IronBitCoreKitStorage`
- Dùng entity/value object/use case: `IronBitCoreKitDomain`
- Dùng repository pattern: `IronBitCoreKitRepository`
- Dùng ViewModel/ViewState/effect/binding: `IronBitCoreKitMVVM`
- Dùng auth/OAuth/biometric/session/crypto: `IronBitCoreKitSecurity`
- Dùng analytics/feature flag/remote config: `IronBitCoreKitAnalytics`
- Dùng mock, spy, stub, fake, async assertions trong test: `IronBitCoreKitTesting`
- Dùng dev menu và environment switcher trong Debug: `IronBitCoreKitDev`

### Import Vào Code

Import module tương ứng với product đã add:

```swift
import IronBitCoreKit
import IronBitCoreKitUI
import IronBitCoreKitNetwork
```

Ví dụ một file SwiftUI dùng UI module:

```swift
import IronBitCoreKitUI
import SwiftUI

struct ContentView: View {
    var body: some View {
        IBButton("Tiếp tục") {
            print("Continue")
        }
        .ironBitTheme(DefaultTheme())
    }
}
```

## Module

| Target | Mục đích |
| --- | --- |
| `IronBitCoreKit` | Core utilities, extensions, logging, error handling, dependency injection, concurrency helpers. |
| `IronBitCoreKitUI` | Design tokens, theme environment, SwiftUI components, state views, modifiers, layout, forms, media, animation, accessibility, localization, preview helpers. |
| `IronBitCoreKitNavigation` | Coordinator, route abstraction, router, route registry, deep link, tab coordinator, sheet coordinator, flow coordinator. |
| `IronBitCoreKitNetwork` | Endpoint, request builder, URLSession client, retry, timeout, interceptor, decoding, cache, reachability, security, mock network client. |
| `IronBitCoreKitStorage` | Storage protocols, type-safe keys, UserDefaults, Keychain, file storage, SwiftData, CoreData, cache. |
| `IronBitCoreKitDomain` | Entity, value object, validation/domain errors, use case abstractions. |
| `IronBitCoreKitRepository` | Readable/writable/streamable repository contracts, DTO mapper, network/local/hybrid repositories, sync strategies, mock repository. |
| `IronBitCoreKitMVVM` | ViewModel protocol/base class, ViewState, StateContainer, ViewAction dispatcher, binding helpers, effects, cancellable task, preview mock view model. |
| `IronBitCoreKitSecurity` | Auth token/state/service, OAuth2 + PKCE, biometric auth, session management, auto logout, crypto/hash/random helpers. |
| `IronBitCoreKitAnalytics` | Analytics provider/service, event/screen tracking, crash logging, performance monitor, remote config, A/B testing, feature flags. |
| `IronBitCoreKitTesting` | Mock helpers, spy/stub/fake, snapshot helpers, async XCTest assertions. |
| `IronBitCoreKitDev` | Debug-only dev menu, environment switcher, mock data provider, preview container. |

## Ví Dụ Nhanh

### UI Theme

```swift
import IronBitCoreKitUI
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            IBText("IronBitCoreKit", variant: .title)
            IBButton("Bắt đầu") {
                print("Tapped")
            }
        }
        .padding()
        .ironBitTheme(DefaultTheme())
    }
}
```

### Network

```swift
import Foundation
import IronBitCoreKitNetwork

let client = URLSessionNetworkClient()
let request = URLRequest(url: URL(string: "https://example.com")!)
let response: Response<Data> = try await client.data(for: request)
```

### Navigation

```swift
import IronBitCoreKitNavigation

struct HomeRoute: Route {
    let routeIdentifier: RouteIdentifier = "home"
}

let router = NavigationRouter()
router.push(HomeRoute())
```

### MVVM State

```swift
import IronBitCoreKitMVVM

enum HomeAction: ViewAction {
    case onAppear
}

@MainActor
final class HomeViewModel: BaseViewModel<HomeAction> {
    let state = StateContainer<[String]>()

    override func send(_ action: HomeAction) {
        state.setLoaded(["A", "B", "C"])
    }
}
```

## Examples

Mỗi example là một Swift package riêng nằm trong `Examples/`.

```bash
swift build --package-path Examples/BasicApp
swift build --package-path Examples/NetworkExample
swift build --package-path Examples/NavigationExample
swift build --package-path Examples/FullStackExample
```

Chạy từng example:

```bash
cd Examples/BasicApp
swift run
```

Danh sách example:

- `Examples/BasicApp`: demo UI cơ bản với `IronBitCoreKitUI`.
- `Examples/NetworkExample`: demo gọi API bằng mock network client.
- `Examples/NavigationExample`: demo route/router/coordinator.
- `Examples/FullStackExample`: demo MVVM + Repository + Navigation + UI.

## Documentation

DocC nằm tại:

```text
Documentation/IronBitCoreKit.docc/
```

Các bài viết chính:

- `GettingStarted.md`
- `Architecture.md`
- `Articles/DependencyInjection.md`
- `Articles/Networking.md`
- `Articles/Navigation.md`
- `Articles/Theming.md`
- `Articles/Testing.md`

Mỗi target cũng có README riêng tại:

```text
Sources/<TargetName>/README.md
```

## Kiểm Tra

Chạy toàn bộ test của package:

```bash
swift test
```

Build toàn bộ package:

```bash
swift build
```

## Migration

Package hiện đang ở giai đoạn `0.1.0`, chưa có version public cũ để migrate.

Khi có breaking change, hướng dẫn migration sẽ được cập nhật ở:

- `CHANGELOG.md`
- `Documentation/IronBitCoreKit.docc/Architecture.md`
- README của target liên quan trong `Sources/<TargetName>/README.md`

## Quy Tắc Cập Nhật Tài Liệu

Mỗi khi tạo module, thư mục, file, API hoặc tính năng mới, cần cập nhật:

- `README.md`
- `CHANGELOG.md`
- DocC liên quan trong `Documentation/IronBitCoreKit.docc/`
- README của target liên quan trong `Sources/<TargetName>/README.md`

Quy tắc này giúp tài liệu luôn phản ánh đúng cấu trúc và khả năng hiện tại của package.

## License

Xem [LICENSE](LICENSE).
