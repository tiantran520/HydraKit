# Architecture

IronBitCoreKit được chia thành nhiều target nhỏ, mỗi target chịu trách nhiệm cho một lớp chức năng rõ ràng.

## Nguyên Tắc

- Tách module theo trách nhiệm.
- Ưu tiên protocol-oriented design.
- Dùng async/await cho API bất đồng bộ.
- Public API có DocC comment.
- Tránh phụ thuộc vòng giữa các module.
- Cập nhật README/DocC khi thêm module, file, API hoặc tính năng mới.

## Nhóm Module

- `IronBitCoreKit`: core utilities, logging, error handling, DI, concurrency helpers.
- `IronBitCoreKitUI`: design tokens, theme, component library, state views, layout, forms, media, accessibility, localization.
- `IronBitCoreKitNavigation`: coordinator, route abstraction, router, deep link, tab/sheet/flow coordinators.
- `IronBitCoreKitNetwork`: endpoint, request builder, URLSession client, retry, interceptor, decoding, cache, reachability, security, mock.
- `IronBitCoreKitStorage`: key-value store, UserDefaults, Keychain, file storage, SwiftData, CoreData, cache.
- `IronBitCoreKitDomain`: entity, value object, validation/domain errors, use case abstraction.
- `IronBitCoreKitRepository`: readable/writable/streamable repositories, DTO mapper, network/local/hybrid strategies, mock.
- `IronBitCoreKitMVVM`: ViewModel, ViewState, ViewAction, binding helpers, effects, preview mocks.
- `IronBitCoreKitSecurity`: auth, OAuth2/PKCE, biometric, session, crypto helpers.
- `IronBitCoreKitAnalytics`: event/screen tracking, crash reporting, performance, remote config, A/B testing, feature flags.
- `IronBitCoreKitTesting`: mocks, test doubles, snapshot helpers, async assertions.
- `IronBitCoreKitDev`: debug-only dev menu, environment switcher, preview helpers.

## Dependency Direction

App layer nên phụ thuộc vào các module IronBitCoreKit. Các module hạ tầng như Network/Storage/Repository được thiết kế bằng protocol để Domain và MVVM không cần biết implementation cụ thể.

## Migration

Hiện package đang ở giai đoạn `0.1.0`, chưa có version public cũ để migrate. Khi có breaking change, hướng dẫn migration sẽ được thêm vào tài liệu này và `CHANGELOG.md`.
