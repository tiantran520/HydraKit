# IronBitCoreKitTesting

Testing target của IronBitCoreKit.

## Mục Đích

Mocks, test doubles, snapshot helpers và async XCTest assertions.

## Cài Đặt

Thêm product tương ứng vào target app hoặc module của bạn:

```swift
.product(name: "IronBitCoreKitTesting", package: "IronBitCoreKit")
```

## Sử Dụng

```swift
import IronBitCoreKitTesting
```

## Ghi Chú Migration

Hiện chưa có version public cũ của `IronBitCoreKitTesting`. Khi có breaking change, hướng dẫn migration sẽ được cập nhật trong file này, `CHANGELOG.md` và DocC.
