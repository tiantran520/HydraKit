# HydraKitUI: hướng dẫn sử dụng

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
| [Input](../../../Sources/HydraKitUI/Components/Input/) | HKButton, HKTextField, HKSecureField, HKPicker, HKToggle, HKSearchBar | Nhập dữ liệu qua Binding hoặc action |
| [Display](../../../Sources/HydraKitUI/Components/Display/) | HKText, HKAvatar, HKBadge, HKPrice, HKAsyncImage | Hiển thị nội dung và ảnh |
| [Container](../../../Sources/HydraKitUI/Components/Container/) | HKCard, HKSection, HKRow, HKList, HKGrid, HKAccordion | Gom nhóm nội dung |
| [Feedback](../../../Sources/HydraKitUI/Components/Feedback/) | HKProgressView, HKLoadingOverlay, HKSkeleton | Tiến trình, placeholder |
| [Overlay](../../../Sources/HydraKitUI/Components/Overlay/) | HKAlert, HKToast, HKSnackbar, HKBottomSheet, HKModal | Nội dung overlay do app bố trí |
| [Navigation](../../../Sources/HydraKitUI/Components/Navigation/) | HKNavigationBar, HKTabBar, HKBreadcrumb | Phần hiển thị điều hướng |
| [Layout](../../../Sources/HydraKitUI/Components/Layout/) | HKStack, HKScrollView, HKSpacer, HKRefreshControl | Bố trí và refresh |

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

[Layout](../../../Sources/HydraKitUI/Layout/) có AdaptiveStack, FlowLayout, GridLayout. [Modifiers](../../../Sources/HydraKitUI/Modifiers/) có card style, shimmer, conditional modifier, onFirstAppear; dùng onFirstAppear khi chỉ muốn thực hiện một lần trong vòng đời instance view, không dùng thay cơ chế quản lý task.

[Media](../../../Sources/HydraKitUI/Media/) có ImageCache và VideoPlayerView; API dựa trên platform framework. HKAsyncImage là component ảnh ở nhóm Display. App quyết định URL, placeholder và phạm vi cache theo API cụ thể.

## Form, animation, accessibility và localization

`InputMask(pattern: "###-###").apply(to: "123456")` trả `123-456`; helper lọc chữ số và format, không validate số điện thoại. Dùng FormValidator cho rule, thêm validation nghiệp vụ tại Domain.

[Animation](../../../Sources/HydraKitUI/Animation/) có animation curves, transition preset và haptic helpers. Thử haptic trên thiết bị hỗ trợ. `.dynamicTypeFriendly()` hỗ trợ line policy; vẫn cần kiểm tra UI với cỡ chữ lớn. `HKContrastHelper` chọn màu theo color scheme, không đo tỷ lệ tương phản.

`Text(LocalizedString("profile.title"))` dùng localized key; app cần cung cấp string catalog/bản dịch. Locale helpers và HKRTLSupport hỗ trợ nhận diện RTL; kiểm tra layoutDirection khi tạo layout tùy chỉnh.

## Preview

Dùng `.ironBitPreview(theme:)` cho theme, padding và preview layout. PreviewDevice presets chỉ có khi DEBUG. Mỗi component có #Preview trong source để xem initializer và các variant thực tế.

## API component nền tảng

Xem [hướng dẫn component](Components.md) cho API, defaults, states, localization, accessibility, previews và giới hạn kiểm thử của Button, Text/Label, TextField/SecureField, Toggle/Checkbox, Image/Icon/AsyncImage và Card. Theme hỗ trợ thêm `controls: ControlTokens` và `ColorTokens.onPrimary`.

Field styles `.floating` và `.stacked` dùng typography, spacing, radius, semantic colors, shadow và animation từ theme hiện có. Không cần cập nhật custom Theme; `.standard` tiếp tục giữ giao diện cũ.

HKSwitch dùng ControlTokens cho chiều cao/symbol, spacing cho khoảng cách, colors cho track/núm và animation tokens cho chuyển trạng thái. Có thể override on/off StateAppearance mà không tạo Theme mới; custom Theme cũ tiếp tục hoạt động.

HKParallaxCarousel mặc định lấy spacing.md và radius.lg từ theme. Card height, viewport width ratio và parallax strength là cấu hình riêng của carousel; background/overlay do caller compose bằng các component hoặc assets hiện có.
