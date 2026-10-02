# HydraKit

HydraKit là Swift Package đa nền tảng dành cho ứng dụng Apple, được thiết kế theo hướng module hóa, dễ kiểm thử và dễ mở rộng.

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
git@github.com:tiantran520/HydraKit.git
```

### Cài Bằng Xcode

1. Mở project trong Xcode.
2. Chọn `File` > `Add Package Dependencies...`.
3. Dán URL repository:

```text
git@github.com:tiantran520/HydraKit.git
```

4. Chọn dependency rule phù hợp. Trong giai đoạn đang phát triển, dùng `Branch` là `main`. Không chọn `Up to Next Major Version` nếu repository chưa có Git tag release như `1.0.0`.
5. Chọn target app cần sử dụng package.
6. Tick các product cần add, ví dụ: `HydraKit`, `HydraKitUI`, `HydraKitNetwork`, `HydraKitNavigation`, `HydraKitStorage`.

Sau khi Xcode resolve xong, import module cần dùng trong source code.

Lưu ý: không add `HydraKitTesting` vào app target. Product này dùng `XCTest`, chỉ add vào test target như `MyAppTests`.

### Cài Bằng Swift Package Manager

Nếu project của bạn là Swift package, thêm dependency vào `Package.swift`:

```swift
dependencies: [
    .package(url: "git@github.com:tiantran520/HydraKit.git", branch: "main")
]
```

Sau đó khai báo product cần dùng trong target:

```swift
.target(
    name: "MyApp",
    dependencies: [
        .product(name: "HydraKit", package: "HydraKit"),
        .product(name: "HydraKitUI", package: "HydraKit"),
        .product(name: "HydraKitNetwork", package: "HydraKit")
    ]
)
```

### Lỗi Khi Add Package Theo Version

Nếu Xcode báo lỗi tương tự:

```text
Failed to resolve dependencies because no versions of 'hydrakit' match the requirement 1.0.0..<2.0.0
```

Nguyên nhân là Xcode đang dùng rule `Up to Next Major Version` với version `1.0.0`, nhưng repository chưa có Git tag `1.0.0`.

Cách xử lý nhanh trong Xcode:

1. Xóa package dependency vừa add lỗi.
2. Chọn `File` > `Add Package Dependencies...`.
3. Dán lại URL `git@github.com:tiantran520/HydraKit.git`.
4. Ở `Dependency Rule`, chọn `Branch`.
5. Nhập branch `main`.
6. Add lại các product cần dùng.

Nếu muốn dùng rule theo version, repository cần có tag release trước:

```bash
git tag 1.0.0
git push origin 1.0.0
```

Sau khi tag đã được push lên GitHub, bạn có thể add package bằng `Up to Next Major Version` với version `1.0.0`.

### Lỗi Link XCTest Khi Add Package

Nếu app target báo lỗi như:

```text
Could not find or use auto-linked framework 'XCTest'
Undefined symbols for architecture arm64: XCTest.XCTFail
```

Nguyên nhân thường là app target đang link nhầm `HydraKitTesting`. Module này dùng `XCTest`, nên chỉ dành cho test target.

Cách xử lý trong Xcode:

1. Chọn project app.
2. Chọn app target, ví dụ `MyApp`.
3. Vào `General` > `Frameworks, Libraries, and Embedded Content`.
4. Xóa `HydraKitTesting` khỏi app target nếu có.
5. Chọn test target, ví dụ `MyAppTests`.
6. Add `HydraKitTesting` vào test target nếu cần dùng mock, spy, stub, fake hoặc async assertions.
7. Chọn `Product` > `Clean Build Folder`, rồi build lại.

### Chọn Product Theo Nhu Cầu

Bạn không cần add toàn bộ package nếu app chỉ dùng một phần. Nên chọn module theo tính năng:

- Dùng utilities, logging, DI: `HydraKit`
- Dùng SwiftUI component/theme: `HydraKitUI`
- Dùng API client/cache/interceptor: `HydraKitNetwork`
- Dùng coordinator/router/deep link: `HydraKitNavigation`
- Dùng UserDefaults/Keychain/File/CoreData/SwiftData/cache: `HydraKitStorage`
- Dùng entity/value object/use case: `HydraKitDomain`
- Dùng repository pattern: `HydraKitRepository`
- Dùng ViewModel/HKViewState/effect/binding: `HydraKitMVVM`
- Dùng auth/OAuth/biometric/session/crypto: `HydraKitSecurity`
- Dùng analytics/feature flag/remote config: `HydraKitAnalytics`
- Dùng mock, spy, stub, fake, async assertions trong test target: `HydraKitTesting`
- Dùng dev menu và environment switcher trong Debug: `HydraKitDev`

### Import Vào Code

Import module tương ứng với product đã add:

```swift
import HydraKit
import HydraKitUI
import HydraKitNetwork
```

Ví dụ một file SwiftUI dùng UI module:

```swift
import HydraKitUI
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
| `HydraKit` | [README](Sources/HydraKit/README.md) | [Sources/HydraKit](Sources/HydraKit/) |
| `HydraKitUI` | [README](Sources/HydraKitUI/README.md) | [Sources/HydraKitUI](Sources/HydraKitUI/) |
| `HydraKitNavigation` | [README](Sources/HydraKitNavigation/README.md) | [Sources/HydraKitNavigation](Sources/HydraKitNavigation/) |
| `HydraKitNetwork` | [README](Sources/HydraKitNetwork/README.md) | [Sources/HydraKitNetwork](Sources/HydraKitNetwork/) |
| `HydraKitStorage` | [README](Sources/HydraKitStorage/README.md) | [Sources/HydraKitStorage](Sources/HydraKitStorage/) |
| `HydraKitDomain` | [README](Sources/HydraKitDomain/README.md) | [Sources/HydraKitDomain](Sources/HydraKitDomain/) |
| `HydraKitRepository` | [README](Sources/HydraKitRepository/README.md) | [Sources/HydraKitRepository](Sources/HydraKitRepository/) |
| `HydraKitMVVM` | [README](Sources/HydraKitMVVM/README.md) | [Sources/HydraKitMVVM](Sources/HydraKitMVVM/) |
| `HydraKitSecurity` | [README](Sources/HydraKitSecurity/README.md) | [Sources/HydraKitSecurity](Sources/HydraKitSecurity/) |
| `HydraKitAnalytics` | [README](Sources/HydraKitAnalytics/README.md) | [Sources/HydraKitAnalytics](Sources/HydraKitAnalytics/) |
| `HydraKitTesting` | [README](Sources/HydraKitTesting/README.md) | [Sources/HydraKitTesting](Sources/HydraKitTesting/) |
| `HydraKitDev` | [README](Sources/HydraKitDev/README.md) | [Sources/HydraKitDev](Sources/HydraKitDev/) |

### DocC Articles

| Chủ đề | Link |
| --- | --- |
| Landing page | [Documentation/HydraKit.docc/HydraKit.md](Documentation/HydraKit.docc/HydraKit.md) |
| Bắt đầu sử dụng | [Documentation/HydraKit.docc/GettingStarted.md](Documentation/HydraKit.docc/GettingStarted.md) |
| Kiến trúc package | [Documentation/HydraKit.docc/Architecture.md](Documentation/HydraKit.docc/Architecture.md) |
| Dependency Injection | [Documentation/HydraKit.docc/Articles/DependencyInjection.md](Documentation/HydraKit.docc/Articles/DependencyInjection.md) |
| Networking | [Documentation/HydraKit.docc/Articles/Networking.md](Documentation/HydraKit.docc/Articles/Networking.md) |
| Navigation | [Documentation/HydraKit.docc/Articles/Navigation.md](Documentation/HydraKit.docc/Articles/Navigation.md) |
| Theming | [Documentation/HydraKit.docc/Articles/Theming.md](Documentation/HydraKit.docc/Articles/Theming.md) |
| Testing | [Documentation/HydraKit.docc/Articles/Testing.md](Documentation/HydraKit.docc/Articles/Testing.md) |

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
| [`HydraKit`](Sources/HydraKit/README.md) | Core utilities, extensions, logging, error handling, dependency injection, concurrency helpers. |
| [`HydraKitUI`](Sources/HydraKitUI/README.md) | Design tokens, theme environment, SwiftUI components, state views, modifiers, layout, forms, media, animation, accessibility, localization, preview helpers. |
| [`HydraKitNavigation`](Sources/HydraKitNavigation/README.md) | Coordinator, route abstraction, router, route registry, deep link, tab coordinator, sheet coordinator, flow coordinator. |
| [`HydraKitNetwork`](Sources/HydraKitNetwork/README.md) | Endpoint, request builder, URLSession client, retry, timeout, interceptor, decoding, cache, reachability, security, mock network client. |
| [`HydraKitStorage`](Sources/HydraKitStorage/README.md) | Storage protocols, type-safe keys, UserDefaults, Keychain, file storage, SwiftData, CoreData, cache. |
| [`HydraKitDomain`](Sources/HydraKitDomain/README.md) | Entity, value object, validation/domain errors, use case abstractions. |
| [`HydraKitRepository`](Sources/HydraKitRepository/README.md) | Readable/writable/streamable repository contracts, DTO mapper, network/local/hybrid repositories, sync strategies, mock repository. |
| [`HydraKitMVVM`](Sources/HydraKitMVVM/README.md) | ViewModel protocol/base class, HKViewState, HKStateContainer, ViewAction dispatcher, binding helpers, effects, cancellable task, preview mock view model. |
| [`HydraKitSecurity`](Sources/HydraKitSecurity/README.md) | Auth token/state/service, OAuth2 + PKCE, biometric auth, session management, auto logout, crypto/hash/random helpers. |
| [`HydraKitAnalytics`](Sources/HydraKitAnalytics/README.md) | Analytics provider/service, event/screen tracking, crash logging, performance monitor, remote config, A/B testing, feature flags. |
| [`HydraKitTesting`](Sources/HydraKitTesting/README.md) | Mock helpers, spy/stub/fake, snapshot helpers, async XCTest assertions. |
| [`HydraKitDev`](Sources/HydraKitDev/README.md) | Debug-only dev menu, environment switcher, mock data provider, preview container. |

## Ví Dụ Nhanh

### UI Theme

```swift
import HydraKitUI
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            IBText("HydraKit", variant: .title)
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
import HydraKitNetwork

let client = HKURLSessionNetworkClient()
let request = URLRequest(url: URL(string: "https://example.com")!)
let response: Response<Data> = try await client.data(for: request)
```

### Navigation

```swift
import HydraKitNavigation

struct HomeRoute: Route {
    let routeIdentifier: RouteIdentifier = "home"
}

let router = HKNavigationRouter()
router.push(HomeRoute())
```

### MVVM HKState

```swift
import HydraKitMVVM

enum HomeAction: ViewAction {
    case onAppear
}

@MainActor
final class HomeViewModel: HKBaseViewModel<HomeAction> {
    let state = HKStateContainer<[String]>()

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

- [`Examples/BasicApp`](Examples/BasicApp/README.md): demo UI cơ bản với `HydraKitUI`.
- [`Examples/NetworkExample`](Examples/NetworkExample/README.md): demo gọi API bằng mock network client.
- [`Examples/NavigationExample`](Examples/NavigationExample/README.md): demo route/router/coordinator.
- [`Examples/FullStackExample`](Examples/FullStackExample/README.md): demo MVVM + Repository + Navigation + UI.

## Documentation

DocC nằm tại:

```text
Documentation/HydraKit.docc/
```

Các bài viết chính:

- [GettingStarted.md](Documentation/HydraKit.docc/GettingStarted.md)
- [Architecture.md](Documentation/HydraKit.docc/Architecture.md)
- [Articles/DependencyInjection.md](Documentation/HydraKit.docc/Articles/DependencyInjection.md)
- [Articles/Networking.md](Documentation/HydraKit.docc/Articles/Networking.md)
- [Articles/Navigation.md](Documentation/HydraKit.docc/Articles/Navigation.md)
- [Articles/Theming.md](Documentation/HydraKit.docc/Articles/Theming.md)
- [Articles/Testing.md](Documentation/HydraKit.docc/Articles/Testing.md)

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
- `Documentation/HydraKit.docc/Architecture.md`
- README của target liên quan trong `Sources/<TargetName>/README.md`

## Quy Tắc Cập Nhật Tài Liệu

Mỗi khi tạo module, thư mục, file, API hoặc tính năng mới, cần cập nhật:

- `README.md`
- `CHANGELOG.md`
- DocC liên quan trong `Documentation/HydraKit.docc/`
- README của target liên quan trong `Sources/<TargetName>/README.md`

Quy tắc này giúp tài liệu luôn phản ánh đúng cấu trúc và khả năng hiện tại của package.

## License

Xem [LICENSE](LICENSE).
