# Architecture

HydraKit được chia thành nhiều target nhỏ, mỗi target chịu trách nhiệm cho một lớp chức năng rõ ràng.

## Nguyên Tắc

- Tách module theo trách nhiệm.
- Ưu tiên protocol-oriented design.
- Dùng async/await cho API bất đồng bộ.
- Public API có DocC comment.
- Tránh phụ thuộc vòng giữa các module.
- Cập nhật README/DocC khi thêm module, file, API hoặc tính năng mới.

## Nhóm Module

- `HydraKit`: core utilities, logging, error handling, DI, concurrency helpers.
- `HydraKitUI`: design tokens, theme, component library, state views, layout, forms, media, accessibility, localization.
- `HydraKitNavigation`: coordinator, route abstraction, router, deep link, tab/sheet/flow coordinators.
- `HydraKitNetwork`: endpoint, request builder, URLSession client, retry, interceptor, decoding, cache, reachability, security, mock.
- `HydraKitStorage`: key-value store, UserDefaults, Keychain, file storage, SwiftData, CoreData, cache.
- `HydraKitDomain`: entity, value object, validation/domain errors, use case abstraction.
- `HydraKitRepository`: readable/writable/streamable repositories, DTO mapper, network/local/hybrid strategies, mock.
- `HydraKitMVVM`: ViewModel, HKViewState, ViewAction, binding helpers, effects, preview mocks.
- `HydraKitSecurity`: auth, OAuth2/PKCE, biometric, session, crypto helpers.
- `HydraKitAnalytics`: event/screen tracking, crash reporting, performance, remote config, A/B testing, feature flags.
- `HydraKitTesting`: mocks, test doubles, snapshot helpers, async assertions.
- `HydraKitDev`: debug-only dev menu, environment switcher, preview helpers.

## Dependency Direction

App layer nên phụ thuộc vào các module HydraKit. Các module hạ tầng như Network/Storage/Repository được thiết kế bằng protocol để Domain và MVVM không cần biết implementation cụ thể.

## Dependency thực tế

| Target | Dependencies trực tiếp |
| --- | --- |
| HydraKit | Không có |
| UI, Network, Domain, MVVM, Security | Core (MVVM thêm Domain) |
| Navigation | Core, UI |
| Storage | Core, Security |
| Repository | Domain, Network, Storage |
| Analytics | Core, Network |
| Testing | Core, Domain, Network, Storage, Repository, MVVM |
| Dev | Core, UI, Navigation, Network, Storage, Repository, MVVM, Analytics |

Danh sách chính xác và public products nằm trong Package.swift. Testing là target nội bộ; Dev types được bảo vệ bởi DEBUG.

## Trách nhiệm của app

Tạo composition root để dựng client/store/repository/use case/ViewModel và đăng ký service. Domain của app nên phụ thuộc contract cần thiết thay vì instance hạ tầng cụ thể. Chỉ import product cần sử dụng trực tiếp.

Protocol AuthService, SessionStore, AnalyticsProvider, RemoteConfigService, FeatureFlagProvider, CrashReporter và CryptoService cần implementation/adapter của app. Router/coordinator chỉ giữ trạng thái, app gắn chúng với SwiftUI hierarchy. Điều này cho phép test bằng mock nhưng cần cấu hình rõ trước khi chạy thật.

## Migration

Đối chiếu CHANGELOG và revision đang tích hợp. Hướng dẫn từng module ghi rõ API hiện tại và giới hạn; khi đổi schema storage hoặc format DTO, app chịu trách nhiệm migration dữ liệu.
