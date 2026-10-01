# IronBitCoreKitTesting

Testing target của IronBitCoreKit.

## Mục Đích

Mocks, test doubles, snapshot helpers và async XCTest assertions.

## Cài Đặt

Chỉ thêm product này vào test target, ví dụ `MyAppTests`. Không thêm `IronBitCoreKitTesting` vào app target vì module này dùng `XCTest`.

```swift
.product(name: "IronBitCoreKitTesting", package: "IronBitCoreKit")
```

Nếu add bằng Xcode, chọn `IronBitCoreKitTesting` ở cột product và gán vào target test, không gán vào target app.

## Sử Dụng

```swift
import IronBitCoreKitTesting
```

Nếu app target báo lỗi link `XCTest`, hãy kiểm tra lại `Frameworks, Libraries, and Embedded Content` của app target và xóa `IronBitCoreKitTesting` khỏi đó.

## Ghi Chú Migration

Hiện chưa có version public cũ của `IronBitCoreKitTesting`. Khi có breaking change, hướng dẫn migration sẽ được cập nhật trong file này, `CHANGELOG.md` và DocC.
