# Nhật Ký Thay Đổi

## Chưa phát hành

- Thêm HKParallaxCarousel với background/overlay ViewBuilder, center snapping giới hạn mỗi lần vuốt một card, selection theo stable ID, Reduce Motion, responsive viewport width, offline previews và geometry/native scroll tests.

- Thêm HKSwitch độc lập với HKToggle: ba variant trackIcon/thumbIcon/labeled, on/off appearance, Binding, disabled, native Toggle accessibility, RTL, Reduce Motion, previews và regression tests.

- Sửa viền lồng nhau trong HKTextField/HKSecureField Legacy: mọi style dùng native input plain và chỉ giữ outline của component.

- Thêm field styles `.floating` và `.stacked` cho HKTextField/HKSecureField, dùng chung native input, focus/validation và design tokens; giữ initializer và style mặc định cũ.

- Bổ sung kiểm tra tương thích ngược cho initializer/factory và custom Theme; giữ native LabelStyle, text-field style, accessibility modifiers, Image rendering mode, button minimum height và placeholder của URL nil khi dùng API cũ.

- Nâng cấp các component SwiftUI nền tảng: button size/loading/icon, field focus/validation, selection accessibility, text layout, image/icon semantics và card customization; bổ sung control tokens, onPrimary, offline previews, regression tests và hướng dẫn API.

- Mở rộng hướng dẫn Tab và flow với TabView, onboarding nhiều bước, validation, hoàn thành và giữ tiến độ.

- Bổ sung hướng dẫn tiếng Việt cho cả 12 target: cấu hình, ví dụ sử dụng, vòng đời, xử lý lỗi và giới hạn tích hợp.
- Mở rộng DocC theo từng module; làm rõ target Testing nội bộ và các helper cần adapter của app.

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

- Add independent HKBankCardStack with Home-style gestures, focused-card Binding, optional delete requests, previews and tests.

- Add HKFlashcardDeck for two-sided English-learning cards, 3D flip, Tinder-style swipe, stable-ID progress, completion/replay, accessible native controls, inline Canvas previews and unit/UI tests.

- Add HKWaterWave with configurable percentage/color, independent animated wave layers, exact empty/full endpoints, native progress accessibility, inline previews and render/UI tests.
