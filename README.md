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

## Điều Hướng Tài Liệu

Dùng các link dưới đây để đi thẳng tới hướng dẫn của từng phần trong cây thư mục project.

### Hướng Dẫn Theo Target

| Target | Tài liệu | Source |
| --- | --- | --- |
| `IronBitCoreKit` | [README](Sources/IronBitCoreKit/README.md) | [Sources/IronBitCoreKit](Sources/IronBitCoreKit/) |
| `IronBitCoreKitUI` | [README](Sources/IronBitCoreKitUI/README.md) | [Sources/IronBitCoreKitUI](Sources/IronBitCoreKitUI/) |
| `IronBitCoreKitNavigation` | [README](Sources/IronBitCoreKitNavigation/README.md) | [Sources/IronBitCoreKitNavigation](Sources/IronBitCoreKitNavigation/) |
| `IronBitCoreKitNetwork` | [README](Sources/IronBitCoreKitNetwork/README.md) | [Sources/IronBitCoreKitNetwork](Sources/IronBitCoreKitNetwork/) |
| `IronBitCoreKitStorage` | [README](Sources/IronBitCoreKitStorage/README.md) | [Sources/IronBitCoreKitStorage](Sources/IronBitCoreKitStorage/) |
| `IronBitCoreKitDomain` | [README](Sources/IronBitCoreKitDomain/README.md) | [Sources/IronBitCoreKitDomain](Sources/IronBitCoreKitDomain/) |
| `IronBitCoreKitRepository` | [README](Sources/IronBitCoreKitRepository/README.md) | [Sources/IronBitCoreKitRepository](Sources/IronBitCoreKitRepository/) |
| `IronBitCoreKitMVVM` | [README](Sources/IronBitCoreKitMVVM/README.md) | [Sources/IronBitCoreKitMVVM](Sources/IronBitCoreKitMVVM/) |
| `IronBitCoreKitSecurity` | [README](Sources/IronBitCoreKitSecurity/README.md) | [Sources/IronBitCoreKitSecurity](Sources/IronBitCoreKitSecurity/) |
| `IronBitCoreKitAnalytics` | [README](Sources/IronBitCoreKitAnalytics/README.md) | [Sources/IronBitCoreKitAnalytics](Sources/IronBitCoreKitAnalytics/) |
| `IronBitCoreKitTesting` | [README](Sources/IronBitCoreKitTesting/README.md) | [Sources/IronBitCoreKitTesting](Sources/IronBitCoreKitTesting/) |
| `IronBitCoreKitDev` | [README](Sources/IronBitCoreKitDev/README.md) | [Sources/IronBitCoreKitDev](Sources/IronBitCoreKitDev/) |

### DocC Articles

| Chủ đề | Link |
| --- | --- |
| Landing page | [Documentation/IronBitCoreKit.docc/IronBitCoreKit.md](Documentation/IronBitCoreKit.docc/IronBitCoreKit.md) |
| Bắt đầu sử dụng | [Documentation/IronBitCoreKit.docc/GettingStarted.md](Documentation/IronBitCoreKit.docc/GettingStarted.md) |
| Kiến trúc package | [Documentation/IronBitCoreKit.docc/Architecture.md](Documentation/IronBitCoreKit.docc/Architecture.md) |
| Dependency Injection | [Documentation/IronBitCoreKit.docc/Articles/DependencyInjection.md](Documentation/IronBitCoreKit.docc/Articles/DependencyInjection.md) |
| Networking | [Documentation/IronBitCoreKit.docc/Articles/Networking.md](Documentation/IronBitCoreKit.docc/Articles/Networking.md) |
| Navigation | [Documentation/IronBitCoreKit.docc/Articles/Navigation.md](Documentation/IronBitCoreKit.docc/Articles/Navigation.md) |
| Theming | [Documentation/IronBitCoreKit.docc/Articles/Theming.md](Documentation/IronBitCoreKit.docc/Articles/Theming.md) |
| Testing | [Documentation/IronBitCoreKit.docc/Articles/Testing.md](Documentation/IronBitCoreKit.docc/Articles/Testing.md) |

### Examples

| Example | Hướng dẫn | Code chính |
| --- | --- | --- |
| BasicApp | [README](Examples/BasicApp/README.md) | [BasicApp.swift](Examples/BasicApp/Sources/BasicApp/BasicApp.swift) |
| NetworkExample | [README](Examples/NetworkExample/README.md) | [NetworkExample.swift](Examples/NetworkExample/Sources/NetworkExample/NetworkExample.swift) |
| NavigationExample | [README](Examples/NavigationExample/README.md) | [NavigationExample.swift](Examples/NavigationExample/Sources/NavigationExample/NavigationExample.swift) |
| FullStackExample | [README](Examples/FullStackExample/README.md) | [FullStackExample.swift](Examples/FullStackExample/Sources/FullStackExample/FullStackExample.swift) |

### File Gốc Cần Biết

| File | Mục đích |
| --- | --- |
| [Package.swift](Package.swift) | Khai báo platforms, products, targets, dependencies và test targets. |
| [CHANGELOG.md](CHANGELOG.md) | Theo dõi thay đổi theo version. |
| [CONTRIBUTING.md](CONTRIBUTING.md) | Quy tắc đóng góp và phát triển. |
| [LICENSE](LICENSE) | License của package. |

## Module

| Target | Mục đích |
| --- | --- |
| [`IronBitCoreKit`](Sources/IronBitCoreKit/README.md) | Core utilities, extensions, logging, error handling, dependency injection, concurrency helpers. |
| [`IronBitCoreKitUI`](Sources/IronBitCoreKitUI/README.md) | Design tokens, theme environment, SwiftUI components, state views, modifiers, layout, forms, media, animation, accessibility, localization, preview helpers. |
| [`IronBitCoreKitNavigation`](Sources/IronBitCoreKitNavigation/README.md) | Coordinator, route abstraction, router, route registry, deep link, tab coordinator, sheet coordinator, flow coordinator. |
| [`IronBitCoreKitNetwork`](Sources/IronBitCoreKitNetwork/README.md) | Endpoint, request builder, URLSession client, retry, timeout, interceptor, decoding, cache, reachability, security, mock network client. |
| [`IronBitCoreKitStorage`](Sources/IronBitCoreKitStorage/README.md) | Storage protocols, type-safe keys, UserDefaults, Keychain, file storage, SwiftData, CoreData, cache. |
| [`IronBitCoreKitDomain`](Sources/IronBitCoreKitDomain/README.md) | Entity, value object, validation/domain errors, use case abstractions. |
| [`IronBitCoreKitRepository`](Sources/IronBitCoreKitRepository/README.md) | Readable/writable/streamable repository contracts, DTO mapper, network/local/hybrid repositories, sync strategies, mock repository. |
| [`IronBitCoreKitMVVM`](Sources/IronBitCoreKitMVVM/README.md) | ViewModel protocol/base class, ViewState, StateContainer, ViewAction dispatcher, binding helpers, effects, cancellable task, preview mock view model. |
| [`IronBitCoreKitSecurity`](Sources/IronBitCoreKitSecurity/README.md) | Auth token/state/service, OAuth2 + PKCE, biometric auth, session management, auto logout, crypto/hash/random helpers. |
| [`IronBitCoreKitAnalytics`](Sources/IronBitCoreKitAnalytics/README.md) | Analytics provider/service, event/screen tracking, crash logging, performance monitor, remote config, A/B testing, feature flags. |
| [`IronBitCoreKitTesting`](Sources/IronBitCoreKitTesting/README.md) | Mock helpers, spy/stub/fake, snapshot helpers, async XCTest assertions. |
| [`IronBitCoreKitDev`](Sources/IronBitCoreKitDev/README.md) | Debug-only dev menu, environment switcher, mock data provider, preview container. |

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

- [`Examples/BasicApp`](Examples/BasicApp/README.md): demo UI cơ bản với `IronBitCoreKitUI`.
- [`Examples/NetworkExample`](Examples/NetworkExample/README.md): demo gọi API bằng mock network client.
- [`Examples/NavigationExample`](Examples/NavigationExample/README.md): demo route/router/coordinator.
- [`Examples/FullStackExample`](Examples/FullStackExample/README.md): demo MVVM + Repository + Navigation + UI.

## Documentation

DocC nằm tại:

```text
Documentation/IronBitCoreKit.docc/
```

Các bài viết chính:

- [GettingStarted.md](Documentation/IronBitCoreKit.docc/GettingStarted.md)
- [Architecture.md](Documentation/IronBitCoreKit.docc/Architecture.md)
- [Articles/DependencyInjection.md](Documentation/IronBitCoreKit.docc/Articles/DependencyInjection.md)
- [Articles/Networking.md](Documentation/IronBitCoreKit.docc/Articles/Networking.md)
- [Articles/Navigation.md](Documentation/IronBitCoreKit.docc/Articles/Navigation.md)
- [Articles/Theming.md](Documentation/IronBitCoreKit.docc/Articles/Theming.md)
- [Articles/Testing.md](Documentation/IronBitCoreKit.docc/Articles/Testing.md)

Mỗi target cũng có README riêng tại [`Sources/<TargetName>/README.md`](Sources/).

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
