# Nhật Ký Thay Đổi

## 0.1.0

- Khởi tạo skeleton Swift Package Manager cho IronBitCoreKit.
- Thêm các target chính và test target tương ứng.
- Triển khai nền tảng ban đầu cho `IronBitCoreKit`, `IronBitCoreKitNetwork`, `IronBitCoreKitTesting` và `IronBitCoreKitDev`.
- Triển khai `IronBitCoreKitUI` với design tokens, theme, SwiftUI components, state views, modifiers, layout, forms, media, animation, accessibility, localization và preview helpers.
- Mở rộng `IronBitCoreKitUI/Components` theo nhóm Input, Display, Container, Feedback, Overlay, Navigation và Layout.
- Triển khai `IronBitCoreKitNavigation` với coordinator lifecycle, route abstraction, navigation router, route registry, deep link handling, tab, sheet và flow coordinators.
- Triển khai `IronBitCoreKitStorage` với core protocols, UserDefaults, Keychain, file storage, SwiftData, CoreData và cache.
- Triển khai `IronBitCoreKitDomain` với entity, value object, example entities, domain errors và use case abstractions.
- Triển khai `IronBitCoreKitRepository` với core repository protocols, DTO mapper, network/local/hybrid repositories, sync strategies và mock repository.
- Triển khai `IronBitCoreKitMVVM` với ViewModel, ViewState, ViewAction, binding helpers, effect handling, cancellable task và mock view model cho preview.
- Triển khai `IronBitCoreKitSecurity` với auth, OAuth2/PKCE, biometric auth, session management, auto logout và crypto helpers.
- Triển khai `IronBitCoreKitAnalytics` với analytics provider/service, event/screen tracking, crash reporting, performance monitor, remote config, A/B testing và feature flags.
