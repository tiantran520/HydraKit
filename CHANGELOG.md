# Nhật Ký Thay Đổi

## 0.1.0

- Khởi tạo skeleton Swift Package Manager cho HydraKit.
- Thêm các target chính và test target tương ứng.
- Triển khai nền tảng ban đầu cho `HydraKit`, `HydraKitNetwork`, `HydraKitTesting` và `HydraKitDev`.
- Triển khai `HydraKitUI` với design tokens, theme, SwiftUI components, state views, modifiers, layout, forms, media, animation, accessibility, localization và preview helpers.
- Mở rộng `HydraKitUI/Components` theo nhóm Input, Display, Container, Feedback, Overlay, Navigation và Layout.
- Triển khai `HydraKitNavigation` với coordinator lifecycle, route abstraction, navigation router, route registry, deep link handling, tab, sheet và flow coordinators.
- Triển khai `HydraKitStorage` với core protocols, UserDefaults, Keychain, file storage, SwiftData, CoreData và cache.
- Triển khai `HydraKitDomain` với entity, value object, example entities, domain errors và use case abstractions.
- Triển khai `HydraKitRepository` với core repository protocols, DTO mapper, network/local/hybrid repositories, sync strategies và mock repository.
- Triển khai `HydraKitMVVM` với ViewModel, HKViewState, ViewAction, binding helpers, effect handling, cancellable task và mock view model cho preview.
- Triển khai `HydraKitSecurity` với auth, OAuth2/PKCE, biometric auth, session management, auto logout và crypto helpers.
- Triển khai `HydraKitAnalytics` với analytics provider/service, event/screen tracking, crash reporting, performance monitor, remote config, A/B testing và feature flags.
