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
            IBText("Xin chào", variant: .title)
            IBButton("Tiếp tục") {}
        }
        .padding()
        .ironBitTheme(DefaultTheme())
    }
}
```

## Gọi Network

```swift
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
