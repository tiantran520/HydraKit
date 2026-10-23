# HydraKitUI

## Cài đặt

Thêm product vào target sử dụng (xem [hướng dẫn cài package](../../README.md#cài-đặt)):

```swift
.product(name: "HydraKitUI", package: "HydraKit")
```

SwiftUI components đọc design tokens từ environment. Dùng module này cho UI nhất quán, form và các trạng thái tải.

## Form đầu tiên

```swift
import SwiftUI
import HydraKitUI

struct ProfileForm: View {
    @State private var name = ""
    @State private var error: String?
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        FormView(title: "Hồ sơ") {
            HKTextField("Tên", text: $name,
                        state: error.map { .error($0) } ?? .normal)
            HKButton("Lưu") {
                error = FormValidator<String>.required().firstError(for: name)
                if error == nil { print("Form hợp lệ") }
            }
            HKButton("Hủy", variant: .tertiary) { name = ""; error = nil }
        }
        .ironBitTheme(colorScheme.defaultHydraTheme)
    }
}
```

App tự xử lý lưu và điều hướng sau validate. `HKTextField` chỉ hiển thị trạng thái truyền vào, không tự validate. `FormValidator` trả lỗi đầu tiên hoặc nil; `FormField` là model dữ liệu, không tự kết nối field UI.

## Theme và tokens

```swift
let theme = DefaultTheme(
    colors: ColorTokens(primary: .purple),
    spacing: SpacingTokens(lg: 20, xl: 28)
)
```

Gắn `.ironBitTheme(theme)` trên root view để descendants nhận theme. Component riêng đọc `@Environment(\.ironBitTheme)`. Token gồm colors, typography, spacing, radius, shadows, animations. DefaultTheme là giá trị; muốn đổi runtime hãy giữ theme trong state và truyền lại modifier.

Tên environment/modifier hiện là `ironBitTheme`, không phải `hydraTheme`. DefaultTheme() không tự đổi theo color scheme; dùng `colorScheme.defaultHydraTheme` như ví dụ để chọn màu dark/light.

## Chọn component

| Nhóm | API tiêu biểu | Mục đích |
| --- | --- | --- |
| [Input](Components/Input/) | HKButton, HKTextField, HKSecureField, HKPicker, HKToggle, HKSearchBar | Nhập dữ liệu qua Binding hoặc action |
| [Display](Components/Display/) | HKText, HKAvatar, HKBadge, HKPrice, HKAsyncImage | Hiển thị nội dung và ảnh |
| [Container](Components/Container/) | HKCard, HKSection, HKRow, HKList, HKGrid, HKAccordion | Gom nhóm nội dung |
| [Feedback](Components/Feedback/) | HKProgressView, HKLoadingOverlay, HKSkeleton | Tiến trình, placeholder |
| [Overlay](Components/Overlay/) | HKAlert, HKToast, HKSnackbar, HKBottomSheet, HKModal | Nội dung overlay do app bố trí |
| [Navigation](Components/Navigation/) | HKNavigationBar, HKTabBar, HKBreadcrumb | Phần hiển thị điều hướng |
| [Layout](Components/Layout/) | HKStack, HKScrollView, HKSpacer, HKRefreshControl | Bố trí và refresh |

Các view overlay/navigation không tự tạo router hay luồng hiển thị toàn app; đọc initializer ở link nhóm và đặt chúng trong hierarchy phù hợp. Binding/action thuộc trách nhiệm state của app.

## Loading, empty và error

```swift
struct NamesView: View {
    let state: HKContentState<[String]>

    var body: some View {
        ContentStateView(state: state, retry: { print("Tải lại") }) { names in
            List(names, id: \.self) { Text($0) }
        }
    }
}
```

Truyền `.loading`, `.empty`, `.error(message)` hoặc `.content(value)`. Mảng rỗng không tự chuyển thành empty. `LoadingView`, `EmptyStateView`, `ErrorStateView`, `RetryView`, `SkeletonView` cũng dùng độc lập được. Đây là state UI riêng, không phải HKViewState của MVVM.

## Layout, media và modifier

[Layout](Layout/) có AdaptiveStack, FlowLayout, GridLayout. [Modifiers](Modifiers/) có card style, shimmer, conditional modifier, onFirstAppear; dùng onFirstAppear khi chỉ muốn thực hiện một lần trong vòng đời instance view, không dùng thay cơ chế quản lý task.

[Media](Media/) có ImageCache và VideoPlayerView; API dựa trên platform framework. HKAsyncImage là component ảnh ở nhóm Display. App quyết định URL, placeholder và phạm vi cache theo API cụ thể.

## Form, animation, accessibility và localization

`InputMask(pattern: "###-###").apply(to: "123456")` trả `123-456`; helper lọc chữ số và format, không validate số điện thoại. Dùng FormValidator cho rule, thêm validation nghiệp vụ tại Domain.

[Animation](Animation/) có animation curves, transition preset và haptic helpers. Thử haptic trên thiết bị hỗ trợ. `.dynamicTypeFriendly()` hỗ trợ line policy; vẫn cần kiểm tra UI với cỡ chữ lớn. `HKContrastHelper` chọn màu theo color scheme, không đo tỷ lệ tương phản.

`Text(LocalizedString("profile.title"))` dùng localized key; app cần cung cấp string catalog/bản dịch. Locale helpers và HKRTLSupport hỗ trợ nhận diện RTL; kiểm tra layoutDirection khi tạo layout tùy chỉnh.

## Preview

Dùng `.ironBitPreview(theme:)` cho theme, padding và preview layout. PreviewDevice presets chỉ có khi DEBUG. Mỗi component có #Preview trong source để xem initializer và các variant thực tế.

## Đọc tiếp

- [Trang tài liệu tổng](../../README.md)
- [Hướng dẫn DocC](../../Documentation/HydraKit.docc/Articles/Theming.md)
- [Tests của module](../../Tests/HydraKitUITests/)

## API component nền tảng

Xem [hướng dẫn component](../../Documentation/HydraKit.docc/Articles/Components.md) cho API, defaults, states, localization, accessibility, previews và giới hạn kiểm thử của Button, Text/Label, TextField/SecureField, Toggle/Checkbox, Image/Icon/AsyncImage và Card. Theme hỗ trợ thêm `controls: ControlTokens` và `ColorTokens.onPrimary`.

`HKTextField` và `HKSecureField` hỗ trợ `style: .floating` (label nổi theo focus/nội dung) hoặc `.stacked` (label phía trên). Không truyền style để giữ `.standard` như cách dùng cũ. Xem hướng dẫn component cho ví dụ và accessibility.

HKTextField/HKSecureField luôn bỏ viền native bên trong (kể cả Legacy), chỉ dùng outline do component quản lý.

## Pill switch

`HKSwitch("Giao diện", isOn: $isDay, variant: .labeled)` là switch riêng với `.trackIcon`, `.thumbIcon` và `.labeled`. Dùng `on`/`off: HKSwitch.StateAppearance` để cấu hình title, SF Symbol và màu track theo trạng thái; `thumbColor`/`thumbForeground` để cấu hình núm. HKToggle giữ nguyên. Xem hướng dẫn component cho ví dụ day/night, defaults và accessibility.

## Parallax carousel

`HKParallaxCarousel(items, selection: $selectedID, cardHeight: 320) { item in ... } overlay: { item in ... }` cung cấp cuộn ngang snap giữa, mỗi lần vuốt dừng ở tối đa một card liền kề, background parallax và foreground tương tác riêng. Items cần Identifiable ID ổn định; spacing/radius theo theme, Reduce Motion tắt parallax. Xem hướng dẫn component cho API, defaults và ví dụ ảnh local/remote.

## Bank card stack

`HKBankCardStack(items, presentation: $mode, selection: $selectedID, cardHeight: 200) { card in ... }` is a separate SwiftUI component inspired by Facepay Home: right/left opens/closes the fan, down/up expands/collapses, and tapping focuses a card. Optional `onDelete` enables an expanded-card reveal and requests removal; the parent owns confirmation and data. Content uses a ViewBuilder and existing theme tokens. See the component guide for API defaults, accessibility, previews and the offline gesture test host.
