# SwiftUI components: API và quy ước

Các component nền tảng của HydraKitUI dùng native SwiftUI, đọc `ironBitTheme` và không xử lý nghiệp vụ. Các initializer cũ được giữ lại. Phiên bản tối thiểu vẫn theo Package.swift: iOS 17, macOS 14, watchOS 10, tvOS 17 và visionOS 1. Không có dependency mới.

## Theme và trạng thái

Gắn `.ironBitTheme(colorScheme.defaultHydraTheme)` ở root nếu muốn theme mặc định thay đổi theo light/dark. `DefaultTheme()` riêng lẻ không tự đổi màu. `ColorTokens.onPrimary` là màu chữ/icon trên nền primary; custom brand phải cấu hình cặp màu có độ tương phản phù hợp. Dark theme mặc định dùng chữ đen trên cyan.

`ControlTokens` tập trung minimumTarget (44), small/medium/largeHeight (44/44/56), small/medium/largeIcon (16/22/32), borderWidth (1), focusBorderWidth (2), disabledOpacity (0.5) và pressedOpacity (0.82). Chỉ dùng chiều cao tối thiểu để nội dung có thể tăng theo Dynamic Type. Theme cũ tự nhận control tokens mặc định qua protocol extension.

```swift
let theme = DefaultTheme(
    colors: ColorTokens(primary: .purple, onPrimary: .white),
    controls: ControlTokens(mediumHeight: 52)
)
```

Selection, text, validation và loading thuộc view cha. Focus có thể do field quản lý hoặc nhận `FocusState<Bool>.Binding`. Dùng `.disabled(...)` trên component hoặc ancestor; không tạo bản sao selection bằng State bên trong.

## HKButton

Nút native nhận `action` và nội dung qua ViewBuilder, hoặc title String. Defaults: `variant: .primary`, `size: .md`, `isLoading: false`, `loadingLabel: Text("Loading")`. Variant gồm primary/secondary/tertiary; size gồm sm/md/lg. Nút giữ hành vi kích hoạt native, có feedback pressed và disabled, tôn trọng Reduce Motion, đầy chiều rộng vùng được cấp và tăng chiều cao khi label xuống dòng.

```swift
HKButton("Lưu", size: .lg, isLoading: isSaving,
         loadingLabel: Text("Đang lưu")) {
    isSaving = true
    // Bắt đầu tác vụ của app; đặt lại isSaving khi tác vụ kết thúc.
}
HKButton("Tiếp tục", systemImage: "arrow.right", iconPlacement: .trailing) {
    advance()
}
HKButton(variant: .secondary) {
    cancel()
} label: {
    Label("action.cancel", systemImage: "xmark")
}
```

Overload `systemImage` dùng symbol trang trí, placement leading/trailing theo layout direction. Khi loading, spinner được ẩn khỏi VoiceOver để không đọc lặp; tên nút được giữ và accessibility value mô tả loading. Nút bị disable và callback cũng có guard khi loading. Parent cần bật loading ngay khi bắt đầu submit; component không quản lý task, debounce hay tự suy ra loading. `HKPrimaryButtonStyle`/`.hkPrimary` dùng cùng style cho native Button.

## HKText và HKLabel

`HKText` nhận String hoặc Text, `variant: .body` (title/headline/body/caption), `color: nil` (theme textPrimary), alignment và lineLimit tùy chọn. Defaults kế thừa alignment/line limit từ environment; khi không có modifier bên ngoài, alignment là leading và số dòng không giới hạn. Typography dùng theme để hỗ trợ Dynamic Type. Không dùng fixed height cho đoạn văn.

`HKLabel` dùng native Label với title String/Text và `systemImage`. Defaults: `iconPlacement: nil` (kế thừa native LabelStyle, thường là leading), `font: nil` (theme body), `color: nil` (theme textPrimary), alignment/lineLimit kế thừa environment. Symbol là trang trí đi cùng title, không đọc riêng.

```swift
HKText(Text("profile.title"), variant: .title)
HKText(description, color: .secondary, alignment: .center)
HKLabel(Text("profile.account"), systemImage: "person.crop.circle")
HKLabel("Tiếp tục", systemImage: "arrow.right", iconPlacement: .trailing)
HKText(description).lineLimit(2)
```

String động được hiển thị nguyên văn để giữ tương thích. Dùng `Text("catalog.key")`, `String(localized:)` và string catalog của app cho localization. Font tùy chỉnh trong theme cần tự hỗ trợ scaling. Nếu đặt lineLimit thì truncation là lựa chọn của caller.

## HKTextField và HKSecureField

Cả hai nhận title String/Text, `text: Binding<String>`, `state: .normal`, `prompt: nil` và `focus: nil`. Ở `.standard`, prompt nil dùng title làm placeholder như trước. Ở `.stacked` và `.floating` đang nổi, prompt nil không thêm placeholder; truyền prompt nếu muốn gợi ý riêng. `.floating` chưa nổi chỉ hiển thị label bên trong ô và tạm ẩn prompt để tránh chồng chữ. SecureField giữ cơ chế che mật khẩu native. State gồm normal/success/error(String?); `errorMessage` trả feedback của error hoặc nil, không chạy validation nghiệp vụ.

```swift
@State private var email = ""
@State private var password = ""
@State private var error: String?
@FocusState private var emailFocused: Bool

// Trong body:
HKTextField(Text("email.title"), text: $email,
            state: error.map { .error($0) } ?? .normal,
            prompt: Text("name@example.com"), focus: $emailFocused)
    .autocorrectionDisabled()
    .onSubmit { emailFocused = false }
HKSecureField("Mật khẩu", text: $password)
```

Có thể áp dụng `.keyboardType(.emailAddress)`, `.textInputAutocapitalization(.never)` và `.textContentType(.emailAddress)` trên iOS; các modifier tùy nền tảng tuân theo availability của SwiftUI. Dùng `.disabled` cho trạng thái disabled. Focus thực tế được gắn vào control bên trong; khi cần điều khiển focus từ parent hãy truyền `$emailFocused` qua tham số `focus`.

Field có border focused, validation color, error icon và text xuống dòng. Error cũng được truyền vào accessibility hint của input, nên không chỉ dựa vào màu. Success chỉ là feedback bằng màu, không thay đổi giá trị hay ngăn submit. App cung cấp error đã localize và cần xác định thời điểm validate/đọc thông báo; component không tự phát announcement. Không đưa nội dung mật khẩu vào error hoặc label.

### Floating và stacked fields

Cả HKTextField/HKSecureField hỗ trợ tham số `style: HKTextFieldStyle` với ba kiểu:

- `.standard`: giữ giao diện và hành vi của các initializer cũ.
- `.floating`: label nằm trong ô khi trống và chưa focus; thu nhỏ lên đường viền khi focus hoặc có nội dung. Đây là giao diện lấy cảm hứng từ Material outlined, không dùng thư viện Material bên ngoài.
- `.stacked`: label luôn nằm phía trên như form đăng nhập, surface nhạt và shadow nhỏ, error nằm bên dưới.

```swift
HKTextField("Email", text: $email, style: .floating, focus: $emailFocused)
HKSecureField("Password", text: $password,
              state: .error("Enter a valid password"), style: .stacked)
```

Tham số `style` là opt-in nên initializer/factory cũ giữ nguyên kiểu. Có overload String và Text cho localized labels. Cả ba style dùng native input `.plain` bên trong vì component đã tự vẽ viền ngoài. `.textFieldStyle(.roundedBorder)` từ ancestor không thêm viền native bên trong, kể cả khi dùng initializer Legacy. Không đổi field thành text thường để mô phỏng secure input.

Floating state được suy ra từ focus và text, kể cả giá trị được parent cập nhật theo chương trình. Không trim nội dung để quyết định vị trí label. Label nổi dùng caption/body của theme, focus/error colors và animation tokens, tôn trọng Reduce Motion. Phần label hiển thị được ẩn khỏi accessibility để tránh đọc lặp; native input luôn có tên ổn định. Layout chừa chỗ cho label nhiều dòng và không nhảy chiều cao khi focus.

Preview bao gồm empty/filled/disabled/error và light/dark/accessibility size. Tests kiểm tra bảng chuyển trạng thái label, native bindings/secure controls, focus-height stability, label/error dài và các API cũ. Có thể xuất gallery offline bằng biến môi trường `HYDRAKIT_PREVIEW_OUTPUT` trỏ đến thư mục có sẵn khi chạy `swift test` trên macOS.

## HKToggle và HKCheckbox

Nhận title String/Text và `isOn: Binding<Bool>`. HKToggle có `variant: .standard` hoặc `.compact`; compact đổi typography, giữ vùng tương tác native. HKCheckbox dùng ToggleStyle vẽ checkbox và accessibility representation của native Toggle, có vùng bấm tối thiểu theo tokens, label nhiều dòng và disabled opacity.

```swift
HKToggle("Thông báo", isOn: $notifications)
HKCheckbox(Text("terms.accept"), isOn: $accepted)
    .disabled(isSaving)
```

Binding là nguồn dữ liệu duy nhất, không có callback riêng hay selection nội bộ. VoiceOver nhận native toggle semantics thay vì chỉ nhìn icon. Khi disabled, control không sửa Binding. Kiểu toggle thực tế theo nền tảng.

## HKSwitch

Switch dạng viên thuốc độc lập với HKToggle, không thay đổi API hay cách vẽ của HKToggle. `isOn: Binding<Bool>` là nguồn dữ liệu duy nhất. Component không tự đổi theme, lưu cài đặt hay chạy nghiệp vụ.

```swift
@State private var isDay = true

// Trong body:
HKSwitch("Giao diện", isOn: $isDay, variant: .labeled, size: .lg,
         on: .init(title: Text("DAY MODE"), systemImage: "sun.max",
                   background: .yellow, foreground: .black),
         off: .init(title: Text("NIGHT MODE"), systemImage: "moon.fill",
                    background: .indigo, foreground: .white),
         thumbColor: .white, thumbForeground: .black)
    .disabled(isSaving)
```

Defaults: `variant: .trackIcon`, `size: .md`, on appearance có symbol checkmark, off appearance có symbol xmark. `title` String/Text là tên accessibility ổn định; String hiển thị nguyên văn, dùng Text với string catalog khi cần localization. State titles là nội dung riêng theo trạng thái, không thay thế tên control.

| Variant | Track | Núm |
| --- | --- | --- |
| `.trackIcon` | Symbol của trạng thái hiện tại, ở đầu đối diện núm | Tròn, không icon |
| `.thumbIcon` | Không có chữ/icon | Symbol của trạng thái hiện tại |
| `.labeled` | Title của trạng thái hiện tại | Symbol của trạng thái hiện tại |

`StateAppearance(title:systemImage:background:foreground:)` mặc định mọi thuộc tính nil. Title nil dùng Text("On")/Text("Off") ở variant labeled; symbol nil không vẽ icon. Background nil dùng theme primary khi on, border khi off; foreground nil dùng onPrimary khi on, textPrimary khi off. `thumbColor`/`thumbForeground` nil dùng surface/textPrimary. Tự chọn cặp màu có tương phản phù hợp khi override, ví dụ chữ đen trên nền vàng. SF Symbol cần tồn tại ở deployment target của app.

Size sm/md/lg lấy smallHeight/mediumHeight/largeHeight từ ControlTokens, luôn ít nhất minimumTarget (mặc định 44 điểm). Kích thước symbol lấy smallIcon/mediumIcon/largeIcon và scale theo Dynamic Type trong giới hạn núm. Nhãn nhiều dòng làm track tăng chiều cao, góc bo giữ theo chiều cao cơ sở để tránh cắt chữ ở các góc. Chiều rộng tối thiểu khoảng hai lần chiều cao cơ sở; caller cần cấp đủ chỗ (mặc định 88 điểm). sm/md có thể cùng chiều cao theo theme mặc định nhưng khác kích thước symbol.

Khi on, núm nằm ở trailing; off nằm ở leading, tự đảo theo RTL. Màu/nội dung và vị trí núm cập nhật cả khi parent đổi Binding bằng code. Native Button xử lý kích hoạt; guard disabled ngăn sửa Binding. Có feedback pressed, viền focus, disabled opacity và animation từ theme. Reduce Motion tắt chuyển động đổi trạng thái.

Accessibility dùng representation của native Toggle, giữ label, on/off value và enabled state của nền tảng. Icon/title trang trí không được đọc lặp. Tests logic kiểm tra số lần ghi Binding, disabled và thay đổi từ parent; render tests kiểm tra vị trí núm LTR/RTL, khung hẹp, minimum target ở chữ nhỏ và label dài. Native AX interaction test báo skip nếu SwiftPM runner không có accessibility bridge; cần app-hosted test để xác minh VoiceOver và keyboard trên thiết bị thực tế.

Preview offline có ba variant, on/off/disabled, label dài, light/dark và accessibility text size. Có thể xuất gallery bằng `HYDRAKIT_PREVIEW_OUTPUT` như field previews. Component hỗ trợ kích hoạt bằng nút, chưa triển khai kéo núm bằng drag gesture; app xử lý tác vụ sau đổi state qua Binding hoặc `.onChange(of:)`.

## HKParallaxCarousel

Carousel ngang với snap giữa, hé card kế bên và parallax chỉ trên background. Foreground overlay đi cùng card, không nhận độ dịch chuyển parallax. Component mới độc lập với HKScrollView và các layout cũ; dùng API SwiftUI từ iOS 17/macOS 14 và không thêm dependency.

```swift
struct Destination: Identifiable {
    let id: UUID
    let title: String
    let imageName: String
}

// Giữ ID trong model của app, không tạo UUID mới mỗi lần body chạy.
@State private var selectedID: Destination.ID?

// Trong body, với destinations từ state/model của app:
HKParallaxCarousel(destinations, selection: $selectedID, cardHeight: 320) { destination in
    Image(destination.imageName)
        .resizable()
        .scaledToFill()
} overlay: { destination in
    VStack(alignment: .leading) {
        Text(destination.title).font(.title2.bold())
        Button("Chi tiết") { open(destination) }
    }
    .foregroundStyle(.white)
    .padding()
}
```

Dữ liệu nhận qua RandomAccessCollection, mỗi phần tử conform Identifiable với ID duy nhất và ổn định. `background`/`overlay` là ViewBuilder, không gắn tên asset, URL, navigation hay business logic vào component. Có initializer chỉ nhận background khi không cần overlay. Remote image có thể dùng HKAsyncImage trong background với placeholder/failure do app cung cấp; previews không dùng mạng.

| Tham số | Mặc định và ý nghĩa |
| --- | --- |
| `selection` | nil: quản lý vị trí nội bộ; truyền Binding<ID?> để quan sát hoặc điều khiển card |
| `cardHeight` | Bắt buộc, chiều cao card tính bằng điểm |
| `cardWidthRatio` | 0.85, tỷ lệ chiều rộng card so với viewport |
| `parallaxStrength` | 0.2, cường độ dịch chuyển tương đối; 0 tắt hiệu ứng |
| `spacing` | nil dùng theme.spacing.md |
| `cornerRadius` | nil dùng theme.radius.lg |
| `showsIndicators` | false, bật/tắt scroll indicators native |
| `background` | Nội dung nền, cần tự cấu hình resizable/aspect ratio cho Image |
| `overlay` | Nội dung foreground, mặc định căn bottom-leading; tự bố trí/padding qua ViewBuilder |

Width ratio được giới hạn tối đa 1; giá trị không dương hoặc không hữu hạn dùng 0.85. Strength giới hạn 0...1, giá trị không hữu hạn tắt hiệu ứng. Height/spacing/radius không hữu hạn hoặc âm trở thành 0 để tránh truyền frame không hợp lệ cho SwiftUI. Chiều cao là lựa chọn của caller: với title dài, nút hoặc Dynamic Type lớn, tăng cardHeight hoặc dùng ScaledMetric ở app cho đủ không gian overlay.

Native ScrollView/LazyHStack quản lý cuộn. HKCarouselScrollBehavior dùng SwiftUI ScrollTargetBehavior để giới hạn điểm dừng ở card hiện tại hoặc một card liền kề, kể cả khi quán tính dự đoán đi xa hơn, từ iOS 17/macOS 14. Kéo ngắn có thể trở về card hiện tại; đầu/cuối không cuộn vòng. Giới hạn áp dụng cho điểm dừng sau khi thả tay, không khóa vị trí ngón tay trong lúc kéo. Dùng ScrollTargetBehavior từ iOS 17, không thêm DragGesture cạnh tranh với thao tác trong overlay. Hai content margins bằng nhau giúp card đầu/cuối cũng căn giữa. ScrollViewReader căn giữa selection ban đầu và căn lại khi danh sách ID hoặc chiều rộng viewport thay đổi; scrollPosition nhận lệnh từ selection. Sau khi thả tay, selection được cập nhật theo card tại điểm snap đã tính; không dùng ID native trả về trong lúc kéo vì khi nhiều card hẹp cùng hiện trọn vẹn, ID đó có thể là card bên cạnh. Parent vẫn có thể nhảy trực tiếp tới bất kỳ selectedID hợp lệ, không bị giới hạn một bước; dùng `withAnimation` nếu muốn chuyển card có animation. Không có auto-play, vòng lặp vô hạn hoặc network loader riêng.

Selection ban đầu nil được điền ID đầu tiên. Khi data đổi thứ tự, giữ selection theo ID; nếu selected item bị xóa hoặc ID không hợp lệ, dùng item đầu còn lại. Data rỗng xóa selection và làm carousel cao 0; nếu caller tự bọc frame(height:) bên ngoài thì vùng đó vẫn do caller quản lý. Nil phát sinh từ native scroll không bị ép về đầu ở mỗi frame. Khi không truyền Binding, component chỉ giữ một local selection; khi có Binding, không tạo bản sao selection.

Background được cấp thêm chiều rộng và dịch chuyển ngược vị trí card bằng visualEffect; offset được giới hạn trong overscan nên không lộ mép trống. Không ghi geometry vào State hoặc cập nhật binding ở mỗi frame để tính parallax. Reduce Motion tắt offset và overscan, đồng thời bỏ animation giao dịch ở vùng scroll. Native scrolling vẫn hoạt động bình thường.

Background không nhận hit testing, overlay vẫn nhận thao tác bình thường. Accessibility giữ các child elements của card; Text/Button trong overlay và mô tả của image thuộc trách nhiệm caller. Tránh đọc lặp mô tả ảnh/title khi cùng nội dung. RTL dùng layout/scroll semantics native, còn parallax tính theo vị trí vật lý nên không đảo dấu hai lần. Không biến toàn card thành button hay gộp các nút con thành một accessibility label.

Tests kiểm tra giới hạn một card cho quán tính lớn hai chiều, kéo ngắn, biên đầu/cuối, một card/khung rộng 0, offset/overscan, Reduce Motion, geometry không hợp lệ, selection qua reorder/remove/empty, layout ở khung hẹp/iPad, native scroll position và button overlay. Native integration tests chạy trên macOS; build iOS Simulator kiểm tra availability. Fixture app-hosted XCUITest tại Tests/Fixtures/CarouselGestureHost kiểm tra vuốt nhanh LTR/RTL, card hẹp, resize, nhảy selection và biên cuối, kèm kiểm tra card được chọn thực sự căn giữa. VoiceOver và cảm giác thao tác trên thiết bị thật vẫn cần kiểm tra thủ công. Các lỗi availability có sẵn ở các file khác trên watchOS/tvOS/visionOS vẫn như ghi chú cuối tài liệu.

Preview có selection điều khiển từ button, parallax bật/tắt, nhiều card, empty data và light/dark/accessibility text size. Dùng `HYDRAKIT_PREVIEW_OUTPUT` khi chạy tests để xuất ảnh native carousel vào thư mục có sẵn.

## HKBankCardStack

Component mới, độc lập với HKCard/HKParallaxCarousel. Tham khảo chuyển động WECardsView ở Home Facepay; WEAddBankCard trong project tham chiếu là WebView liên kết thẻ, không phải view animation. Component SwiftUI không phụ thuộc UIKit/RxSwift/Facepay hoặc service ngân hàng.

```swift
@State private var presentation: HKBankCardStackPresentation = .collapsed
@State private var selectedID: BankCard.ID?

HKBankCardStack(cards, presentation: $presentation, selection: $selectedID,
                cardHeight: 200,
                onSelect: { card in /* open details in the parent */ },
                onDelete: { card in /* ask for confirmation in the parent */ }) { card in
    BankCardFace(card: card) // Your display-only SwiftUI card face.
}
// Return by tapping the focused card again, or by setting selectedID = nil.
```

| Property | Meaning / default |
| --- | --- |
| items | Front-to-back RandomAccessCollection of Identifiable items; IDs must be unique and stable |
| presentation | Optional Binding; without it, local state starts at .collapsed |
| selection | Optional Binding<ID?> for the focused card; without it, focus is local; default nil |
| cardHeight | Required unscaled height; negative/nonfinite becomes zero |
| spacing | Collapsed peek spacing; nil uses theme spacing.md |
| cornerRadius | Nil uses theme radius.lg |
| onSelect | Optional callback after focus changes; no navigation is performed by the component |
| onDelete | Optional delete-request callback; nil disables swipe-to-reveal; never removes data automatically |
| content | ViewBuilder for display-only content; each card is already wrapped in a native Button |

Presentation .collapsed shows overlapping cards with smaller cards behind; .fanned rotates around the upper-right corner; .expanded separates cards vertically while preserving overlap and depth. Physical right swipe opens the fan; left closes it. Down expands a collapsed stack; up collapses the expanded stack. Vertical gestures do not modify an open fan. Short drags return without action. These physical directions match the reference in both LTR and RTL; card text retains the caller's layout direction.

When expanded and onDelete is supplied, left swipe on a card reveals its delete button; right swipe closes the current reveal first. Pressing the button calls onDelete only. A native context menu and per-card accessibility action provide the same request without requiring a swipe; transformed delete hit areas preserve the theme minimum target. The parent owns confirmation, loading state and removal from items. In expanded mode without a delete callback, a left swipe does not delete anything. A selected card lifts to an unscaled standalone position and hides the other faces; return to the arrangement by tapping the focused card again or clearing selection. onSelect is called only when entering focus, not when dismissing it. Gesture transitions are blocked while a card is selected. Valid selection survives reordering; removal clears a missing ID rather than selecting an unrelated card. Empty data occupies zero height.

Colors, bank logos, account numbers and business permissions belong to content/the parent. Supply an identified “Add bank card” item in data when needed and route its onSelect in the parent; clear selectedID in that callback to avoid focusing the add tile. Do not put nested buttons or scrollable controls in the content closure. This API deliberately contains no bank model, network requests, WebView, or automatic deletion.

The stack measures transformed bounds, fits the settled fan within available width, and reports its actual height to its parent without per-frame layout State. Wrap large expanded stacks in a parent ScrollView. Fixed card geometry is intentional; use @ScaledMetric for cardHeight and wrapping text for larger Dynamic Type, as the offline previews demonstrate. Only existing theme tokens provide spacing, radius, shadows and animation. Reduce Motion turns off arrangement/focus/reveal animation. Parent .disabled applies to gestures and native buttons. VoiceOver receives card labels from content plus named arrangement/return actions; collapsed rear cards and unfocused hidden faces are excluded from accessibility.

Previews cover collapsed/fan/expanded controls, selection, a delete request, an add tile, empty/single data, light/dark, long text, accessibility text sizes and disabled state. Geometry/rules/Binding tests live in BankCardStackTests; the offline app-hosted gesture fixture is in Tests/Fixtures/BankCardStackHost. Device VoiceOver and interaction inside a particular screen's parent ScrollView should also be checked by the integrator.

## HKImage, HKIcon và HKAsyncImage

`HKImage` nhận Image. Defaults: `variant: .rounded` (rectangle/rounded/circle), `contentMode: .fill` (hoặc .fit), `renderingMode: nil` (giữ rendering của ảnh), `accessibilityLabel: nil` (giữ accessibility của Image). Radius rounded lấy từ theme. Parent cấp vùng hiển thị; fit giữ toàn bộ ảnh, fill có thể crop.

`HKIcon` nhận tên SF Symbol. Defaults: `size: .md` (sm/md/lg), `color: nil` (theme primary), `renderingMode: nil`, `accessibilityLabel: nil`. Kích thước lấy từ control tokens và scale theo Dynamic Type. Raw values của HKSize vẫn giữ 16/22/32 để tương thích, nhưng theme quyết định kích thước vẽ.

```swift
HKImage(Image("landscape"), contentMode: .fit,
        accessibilityLabel: Text("Bờ biển lúc hoàng hôn"))
    .frame(height: 180)
HKIcon("checkmark.seal.fill", renderingMode: .hierarchical,
       accessibilityLabel: Text("Đã xác minh"))
```

Ảnh/icon nil label giữ semantics native và các accessibility modifier của caller. Dùng `.accessibilityHidden(true)` khi ảnh chỉ mang tính trang trí. Cung cấp Text đã localize khi ảnh truyền thông tin; icon trong button thường để trang trí và đặt tên cho button. SF Symbol/asset phải tồn tại trên phiên bản hệ điều hành hỗ trợ; component không tự thay tên symbol không hợp lệ.

`HKAsyncImage` nhận `url: URL?`, `contentMode: .fill`, `accessibilityLabel: nil` và placeholder/failure ViewBuilder. Initializer ngắn dùng SkeletonView và photo icon. URL nil giữ placeholder như bản cũ, chờ parent cung cấp URL; URL hợp lệ dùng native AsyncImage cho loading/success/failure. Successful image giữ native accessibility khi không cung cấp label override, tương tự HKImage. Custom loading/failure content giữ accessibility riêng, có thể chứa nút retry do app quản lý.

```swift
HKAsyncImage(url: avatarURL, contentMode: .fit,
             accessibilityLabel: Text("Ảnh đại diện")) {
    ProgressView("Đang tải ảnh")
} failure: {
    Label("Không tải được ảnh", systemImage: "photo")
}
.frame(width: 96, height: 96)
.clipped()
```

AsyncImage không bảo đảm cache riêng, retry hay authentication; app chịu trách nhiệm URL và luồng retry. Default unavailable text là `Text("Image unavailable")`; dùng custom failure để kiểm soát bản dịch và trải nghiệm lỗi. Không cần mạng cho previews.

## HKCard

Container không tương tác, nhận content ViewBuilder. Defaults: `variant: .plain` (plain/outlined/elevated), `padding: nil` (theme lg), `background: nil` (surface), `cornerRadius: nil` (md), `borderColor: nil` (theme border), `borderWidth: nil` (control borderWidth). Border xuất hiện ở outlined hoặc khi truyền borderColor; elevated dùng theme shadow.

```swift
HKCard(variant: .outlined) {
    VStack(alignment: .leading) {
        HKText("Hồ sơ", variant: .headline)
        HKText(description)
        HKButton("Chỉnh sửa") { edit() }
    }
}
```

Không thêm tap gesture hay button trait cho card. Nội dung giữ accessibility elements riêng, phù hợp khi có nhiều control; app có thể combine nội dung chỉ đọc nếu cần. Card không tự đặt chiều rộng/cao, không tự cuộn và không giữ selected/loading state.

## Preview và kiểm thử

Mỗi component trên có preview offline với light/dark theme và Dynamic Type accessibility3. Input preview có Binding cục bộ; button/field/selection preview có trạng thái disabled/loading/error phù hợp và label dài. Các thông số cố định trong preview là khung minh họa, không phải kích thước production.

`LegacyCompatibilityTests` import public module để compile initializer/factory cũ, các kiểu gọi cũ và Theme conformance không khai báo controls. `ComponentBehaviorTests` kiểm tra callback, guard loading và validation feedback. `ComponentHostingTests` kiểm tra layout nhiều dòng ở khung hẹp/rộng, modifier lineLimit, clipping ảnh và render placeholder khi URL nil. Interaction tests dùng AppKit accessibility API; trước khi chạy phải hiệu chuẩn với native Button độc lập. Nếu runner SwiftPM không bật accessibility bridge, tests báo skip với lý do rõ ràng; một component bị mất AX khi bridge hoạt động vẫn là failure. Không xem skip là đã xác minh interaction.

Chạy `swift test` trên macOS. Các hosted interaction tests nằm trong `#if os(macOS)`; cần app-hosted UI test target để kiểm tra thao tác bàn phím, VoiceOver, focus, text entry và các thiết bị iPhone/iPad. Previews và số đo layout không thay thế kiểm tra thủ công accessibility/contrast hay kiểm tra trên thiết bị thật.

Đợt nâng cấp này đã build HydraKitUI cho iOS Simulator với target iOS 17 và chạy suite trên macOS. Deployment targets khai báo trong manifest được giữ nguyên. Build toàn module cho các nền tảng khác hiện bị chặn bởi các file có sẵn ngoài phạm vi nâng cấp: `HapticFeedback.swift` gọi UIKit haptics không khả dụng trên watchOS/visionOS; `HKTextEditor` không khả dụng trên watchOS/tvOS; `HKDatePicker`, `HKSlider` và `HKStepper` dùng control không khả dụng trên tvOS. Các file này chưa được sửa trong đợt này, vì vậy không coi toàn module đã được xác minh build trên watchOS/tvOS/visionOS.

Các nguyên tắc native interaction và focus tham chiếu [Apple HIG: Buttons](https://developer.apple.com/design/human-interface-guidelines/buttons) và [SwiftUI FocusState](https://developer.apple.com/documentation/swiftui/focusstate). Không tuyên bố HIG/accessibility đã được chứng nhận chỉ bằng unit tests.

## Tương thích với cách dùng cũ

Giữ nguyên chữ ký initializer ban đầu, kể cả khi dùng `HKText.init`, `HKButton<Text>.init`, `HKCard<Text>.init`, `HKAsyncImage.init`, `DefaultTheme.init` hoặc `ColorTokens.init` làm factory có kiểu xác định. Các overload mới bổ sung cấu hình và gọi chung implementation; code cũ không cần thêm đối số. Theme tự định nghĩa từ bản cũ không cần khai báo `controls`.

`HKLabel(...).labelStyle(...)`, text lineLimit/alignment, accessibility label/hint/value bên ngoài và rendering mode đã đặt trên Image tiếp tục được giữ khi không truyền override mới. Button mặc định giữ chiều cao tối thiểu 44; URL ảnh nil vẫn hiển thị placeholder. Khi dùng iconPlacement tường minh, layout icon theo cấu hình đó sẽ thay thế native LabelStyle.

Tương thích source không đồng nghĩa ảnh chụp giao diện giống từng pixel: focus/error feedback, disabled/pressed feedback, checkbox accessibility, Dynamic Type và clipping ảnh đã được cải thiện. App có layout rất chặt vẫn cần kiểm tra màn hình thực tế, nhất là nội dung dài và cỡ chữ lớn. Package được phát hành dưới dạng source qua SwiftPM; kiểm tra này không xác nhận ABI cho framework nhị phân build sẵn.

Theo yêu cầu giao diện một lớp viền, HKTextField/HKSecureField luôn dùng `.plain` cho control native bên trong, gồm cả cách gọi Legacy. Thay đổi này có chủ đích thay thế việc kế thừa native text-field style; outline, focus và error border do component quản lý.
