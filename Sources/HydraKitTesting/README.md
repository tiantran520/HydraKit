# HydraKitTesting

Testing target nội bộ của HydraKit.

## Mục Đích

Mocks, test doubles, snapshot helpers và async XCTest assertions.

## Cài Đặt

Từ `1.0.1`, target này không còn được expose thành public library product để tránh app target link nhầm `XCTest`.

Không add `HydraKitTesting` vào app target. Nếu app cũ đang link product này từ `1.0.0`, hãy xóa khỏi `Frameworks, Libraries, and Embedded Content`, sau đó update package lên `1.0.1` hoặc mới hơn.

## Sử Dụng

```swift
import HydraKitTesting
```

Nếu app target báo lỗi link `XCTest`, hãy kiểm tra lại `Frameworks, Libraries, and Embedded Content` của app target và xóa `HydraKitTesting` khỏi đó.

## Ghi Chú Migration

Hiện chưa có version public cũ của `HydraKitTesting`. Khi có breaking change, hướng dẫn migration sẽ được cập nhật trong file này, `CHANGELOG.md` và DocC.
