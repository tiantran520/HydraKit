# Getting Started

Thiết lập HydraKit trong một app mới hoặc app hiện có.

## Yêu Cầu

- Swift 5.10
- iOS 17, macOS 14, watchOS 10, tvOS 17, visionOS 1 trở lên

## Thêm Package

Trong `Package.swift` của app:

```swift
dependencies: [
    .package(url: "git@github.com:tiantran520/HydraKit.git", branch: "main")
]
```

Chọn product theo nhu cầu:

```swift
.product(name: "HydraKitUI", package: "HydraKit"),
.product(name: "HydraKitNetwork", package: "HydraKit"),
.product(name: "HydraKitMVVM", package: "HydraKit")
```

## Dùng UI Theme

```swift
import HydraKitUI
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            HKText("Xin chào", variant: .title)
            HKButton("Tiếp tục") {}
        }
        .padding()
        .ironBitTheme(DefaultTheme())
    }
}
```

## Gọi Network

```swift
import Foundation
import HydraKitNetwork

let client = HKURLSessionNetworkClient()
let request = URLRequest(url: URL(string: "https://example.com")!)
let response: Response<Data> = try await client.data(for: request)
```

## Kiểm Tra Package

Tại thư mục gốc:

```bash
swift test
```

## Examples

- `Examples/BasicApp`: demo UI cơ bản.
- `Examples/NetworkExample`: demo network client.
- `Examples/NavigationExample`: demo coordinator/router.
- `Examples/FullStackExample`: demo MVVM + Repository + Coordinator.

## Lộ trình tích hợp

1. Chọn product cho tính năng cần dùng; `HydraKitTesting` là target nội bộ và không chọn được như public product.
2. Dựng một màn hình với theme và dữ liệu mẫu trước: <doc:Theming>.
3. Thêm endpoint/client và kiểm tra JSON bằng mock: <doc:Networking>.
4. Chọn nơi lưu và repository nếu cần dữ liệu offline: <doc:Storage>, <doc:Repositories>.
5. Đưa nghiệp vụ vào use case và loading/error vào ViewModel: <doc:Domain>, <doc:MVVM>.
6. Gắn router với NavigationStack và thêm destination: <doc:Navigation>.
7. Đăng ký dependency ở composition root: <doc:DependencyInjection>.

## Ghép các lớp trong một tính năng

View gửi ViewAction → ViewModel gọi UseCase → UseCase gọi protocol repository → implementation đọc Network/Storage. Kết quả được ViewModel đưa vào state, view observe state để render. App dựng các instance và inject dependency; HydraKit không tự nối các lớp này.

Ví dụ `Examples/FullStackExample` dùng mock repository để minh họa luồng này; `Examples/NetworkExample` gọi mock client nên không cần server. Đọc source và README của từng example trước khi thay bằng service thật.

## Trước khi chạy trên app thật

- Thay URL example bằng baseURL backend và chọn decoder đúng schema.
- Đăng ký DI trước khi truy cập Injected; cấu hình missing dependency gây crash.
- Bọc phần dùng HydraKitDev bằng `#if DEBUG`.
- Observe HKStateContainer trực tiếp khi view hiển thị state của ViewModel.
- Nối interceptor/cache/session adapter theo hướng dẫn tương ứng; chúng không tự tích hợp vào client.
