# HydraKit

@Metadata {
    @DisplayName("HydraKit")
    @PageKind(article)
}

HydraKit là bộ Swift Package module hóa cho ứng dụng Apple platform.

Package gom các lớp nền tảng thường gặp trong một app hiện đại: core utilities, UI, navigation, networking, storage, domain, repository, MVVM, security, analytics, testing và dev tools.

## Mục Tiêu

- Tách chức năng thành nhiều target nhỏ, dễ import theo nhu cầu.
- Ưu tiên protocol-oriented design để dễ mock, test và thay implementation.
- Dùng async/await cho API bất đồng bộ.
- Giữ public API có DocC comment để sinh tài liệu tự động.
- Cung cấp example có thể chạy độc lập trong `Examples/`.

## Topics

### Bắt Đầu

- <doc:GettingStarted>
- <doc:Architecture>

### Bài Viết

- <doc:DependencyInjection>
- <doc:Networking>
- <doc:Navigation>
- <doc:Theming>
- <doc:Testing>

## Cài Đặt

Thêm package vào Xcode hoặc `Package.swift`:

```swift
.package(url: "git@github.com:tiantran520/IronBitCoreKit.git", branch: "main")
```

Sau đó import target cần dùng:

```swift
import HydraKit
import HydraKitUI
import HydraKitNetwork
```
