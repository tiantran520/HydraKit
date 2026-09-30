# IronBitCoreKit

IronBitCoreKit là bộ Swift Package dùng để xây dựng ứng dụng Apple platform theo hướng module hóa.

Package bao gồm các nhóm chính như core utilities, UI, navigation, network, storage, domain, repository, MVVM, security, analytics, testing và dev tools.

## Yêu cầu

- Swift 5.10
- iOS 17 trở lên
- macOS 14 trở lên
- watchOS 10 trở lên
- tvOS 17 trở lên
- visionOS 1 trở lên

## Kiểm tra package

Chạy lệnh sau tại thư mục gốc của project:

```bash
swift test
```

## Quy tắc cập nhật tài liệu

Mỗi khi tạo module, thư mục, file, API hoặc tính năng mới, cần cập nhật `README.md` và các file Markdown/DocC liên quan để tài liệu luôn khớp với code hiện tại.

## Cấu trúc module

- `IronBitCoreKit`: tiện ích nền tảng, logging, dependency injection, concurrency.
- `IronBitCoreKitUI`: design tokens, theme environment, SwiftUI component library theo nhóm Input, Display, Container, Feedback, Overlay, Navigation, Layout, cùng state views, modifiers, forms, media, animation, accessibility, localization và preview helpers.
- `IronBitCoreKitNavigation`: coordinator, route abstraction, router, route registry, deep link, tab, sheet và flow coordinators.
- `IronBitCoreKitNetwork`: core networking, transport, interceptor, decoding, cache, reachability, security và mock.
- `IronBitCoreKitStorage`: storage core, UserDefaults, Keychain, file storage, SwiftData, CoreData và cache.
- `IronBitCoreKitDomain`: entity, value object, domain errors và use case abstractions.
- `IronBitCoreKitRepository`: repository protocols, DTO mapper, network/local/hybrid repositories, cache-first/network-first sync strategies và mock repository.
- `IronBitCoreKitMVVM`: ViewModel protocol/base class, ViewState, StateContainer, ViewAction dispatcher, binding helpers, effect handling và preview mock view model.
- `IronBitCoreKitTesting`: mock, spy, stub, fake, snapshot và async assertions.
- `IronBitCoreKitDev`: công cụ debug-only cho dev menu, environment switcher và preview.
