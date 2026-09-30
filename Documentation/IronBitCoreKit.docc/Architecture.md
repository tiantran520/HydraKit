# Kiến Trúc

IronBitCoreKit được chia thành nhiều module nhỏ, mỗi module chịu trách nhiệm cho một nhóm chức năng rõ ràng.

## Nguyên Tắc

- Tách module theo trách nhiệm.
- Ưu tiên protocol-oriented design.
- Giữ public API có doc comment.
- Hỗ trợ testability thông qua mock, stub, spy và dependency injection.
- Tránh phụ thuộc vòng giữa các module.

## Nhóm Module

- `IronBitCoreKit`: nền tảng chung như extensions, logging, error, dependency injection và concurrency.
- `IronBitCoreKitUI`: lớp giao diện SwiftUI gồm design tokens, theme environment, component library chia theo Input, Display, Container, Feedback, Overlay, Navigation và Layout, cùng state views, modifiers, layout helpers, forms, media, animation, accessibility, localization và preview helpers.
- `IronBitCoreKitNavigation`: lớp điều hướng gồm coordinator lifecycle, route abstraction, navigation router, route registry, deep link parsing/handling, tab coordinator, sheet coordinator và flow coordinator.
- `IronBitCoreKitNetwork`: networking core, transport, interceptor, decoding, cache, reachability, security và mock.
- `IronBitCoreKitStorage`: storage core, key-value store, database store, UserDefaults, Keychain, file storage, SwiftData, CoreData và unified cache.
- `IronBitCoreKitDomain`: entity, value object, domain errors, validation errors và use case abstractions.
- `IronBitCoreKitRepository`: repository contracts, DTO mapping, network/local/hybrid repository implementations, cache-first/network-first sync strategies và mock repository.
- `IronBitCoreKitMVVM`: lớp presentation logic gồm ViewModel protocol/base class, ViewState, StateContainer, ViewAction dispatcher, binding helpers, effect handling, cancellable task và mock view model cho preview.
- `IronBitCoreKitTesting`: helper phục vụ unit test và snapshot test.
- `IronBitCoreKitDev`: công cụ chỉ dùng trong Debug như dev menu, environment switcher và preview container.

## Hướng Phát Triển

Các module mới nên được thêm theo hướng nhỏ, rõ ràng và có test tương ứng. Với API public, hãy bổ sung doc comment để DocC có thể sinh tài liệu đầy đủ.

Mỗi khi tạo module, thư mục, file, API hoặc tính năng mới, cần cập nhật `README.md` và các file Markdown/DocC liên quan. Quy tắc này giúp tài liệu luôn phản ánh đúng cấu trúc và khả năng hiện tại của package.
