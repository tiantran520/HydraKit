# HydraKitDev

## Cài đặt

Thêm product vào target sử dụng (xem [hướng dẫn cài package](../../README.md#cài-đặt)):

```swift
.product(name: "HydraKitDev", package: "HydraKit")
```

Dev menu, chuyển environment và dữ liệu mock chỉ được compile khi DEBUG. Code của app tham chiếu type thuộc module cũng cần bọc `#if DEBUG` để build Release thành công.

## Menu debug

```swift
#if DEBUG
import SwiftUI
import HydraKitDev

struct DebugScreen: View {
    @StateObject private var environments = HKEnvironmentSwitcher()

    var body: some View {
        NavigationStack {
            DevMenuView(sections: [
                DevMenuSection(title: "Environment", actions: [
                    DevMenuAction(title: "Staging") {
                        environments.switchTo(.staging)
                    },
                    DevMenuAction(title: "Reset") {
                        environments.reset()
                    }
                ])
            ])
        }
    }
}
#endif
```

DevMenuAction chạy handler trên main actor; dùng Task khi cần thao tác async. isDestructive chỉ thay kiểu button; app tự định nghĩa handler và phạm vi dữ liệu thay đổi.

## Environment switcher

Có `.dev`, `.staging`, `.prod`; current là Published private(set). switchTo lưu raw value bằng UserDefaults, reset xóa key và chọn environment truyền vào (mặc định dev). Có thể truyền UserDefaults và storageKey riêng để cô lập test.

Switcher không tự đổi baseURL, token hoặc API client. App quan sát current, map environment sang config rồi dựng lại service/DI cần thiết. Quyết định cách tách cache/session giữa môi trường để tránh dùng dữ liệu nhầm server.

## Dữ liệu mock và preview

```swift
#if DEBUG
let mocks = HKMockDataProvider()
mocks.register("names") { ["An", "Bình"] }
let names = mocks.value([String].self, for: "names") ?? []
#endif
```

Provider dùng String key, factory chạy mỗi lần value được gọi; không có factory hoặc sai type trả nil. reset xóa factories. Không gọi ngược provider từ factory đang resolve vì implementation giữ NSLock trong lúc chạy factory.

`PreviewContainer(environment:mockDataProvider:content:)` truyền provider và environment vào content closure; không tự inject vào SwiftUI environment hoặc DI. Dùng closure để tạo ViewModel/mock data rồi trả view; gắn theme bằng HydraKitUI khi cần.

## Kiểm tra Debug và Release

Nếu Release báo "cannot find type", kiểm tra `#if DEBUG` quanh cả property, initializer và view tham chiếu dev types. Menu không tự được gắn vào app: app chọn cách mở sheet hoặc màn hình debug. Xem [HydraKitDevTests](../../Tests/HydraKitDevTests/HydraKitDevTests.swift) cho ví dụ test environment và provider.

## Đọc tiếp

- [Trang tài liệu tổng](../../README.md)
- [Hướng dẫn DocC](../../Documentation/HydraKit.docc/Articles/DeveloperTools.md)
- [Tests của module](../../Tests/HydraKitDevTests/)
