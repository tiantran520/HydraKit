# HydraKitTesting

## Cài đặt

Target nội bộ dành cho test trong repository; không có public product.

Các helper XCTest **nội bộ** cho test của repository HydraKit. Package.swift hiện có target này nhưng không expose library product; package app bên ngoài không thể thêm `.product(name: "HydraKitTesting", ...)`.

## Dùng trong repository HydraKit

Test target nội bộ khai báo dependency `"HydraKitTesting"`. Chỉ import trong test target:

```swift
import XCTest
import HydraKitTesting

final class ServiceTests: XCTestCase {
    func testRecordedAction() throws {
        let spy = HKSpy<String>()
        spy.record("loaded")
        XCTAssertEqual(spy.callCount, 1)
        XCTAssertEqual(spy.lastValue, "loaded")

        let stub = HKStub<Int, String> { "item-\($0)" }
        XCTAssertEqual(try stub(42), "item-42")
    }

    func testAsyncHelper() async {
        let value = await XCTAssertNoThrowAsync { () async throws -> String in
            "ready"
        }
        XCTAssertEqual(value, "ready")
        await XCTAssertEventually(timeout: 1) { value == "ready" }
    }
}
```

Chạy từ root: `swift test --filter ServiceTests` sau khi đặt test trên trong test target. Để chạy test đã có, dùng `swift test --filter HydraKitTestingTests`.

## Chọn test double

| Helper | Khi dùng |
| --- | --- |
| HKSpy | Ghi input, kiểm tra values/callCount/lastValue; reset giữa lượt test |
| HKStub, HKVoidStub | Trả kết quả hoặc throw qua handler; update để đổi hành vi |
| HKFake | Dictionary RAM với value/setValue/removeValue/removeAll |
| HKMockLogger | Ghi Entry để assert level/category/message/metadata |
| HKMockDIContainer | Đăng ký instance service và resolve theo type |

HKFake không conform KeyValueStore. Mock DI thiếu đăng ký gây preconditionFailure như DI thật; luôn đăng ký trước khi resolve. Không dùng container shared giữa test nếu cần cô lập.

## Async assertions

XCTAssertEventually poll condition đến khi true hoặc timeout; mặc định 1 giây, interval 0.01 giây. Condition throw làm test fail ngay. Dùng khi điều kiện cuối cùng là điều quan tâm, tránh sleep cố định. `XCTAssertNoThrowAsync`, trả optional kết quả; lỗi gây XCTFail và trả nil.

## Snapshot

`HKSnapshotHelper.assertSnapshot(_:named:config:)` so sánh String hoặc Data theo file, không render SwiftUI thành ảnh. Config gồm directory, recordsSnapshots và fileExtension (cho String).

Lần đầu file chưa tồn tại sẽ tự ghi baseline, kể cả recordsSnapshots false. Để CI phát hiện baseline bị thiếu, app/test cần kiểm tra tồn tại trước. Đặt directory rõ ràng, lưu baseline vào repository và chỉ bật recordsSnapshots khi chủ động cập nhật. So sánh Data là byte equality, không có pixel tolerance.

## Với app bên ngoài

Dùng XCTest trực tiếp và các public mocks nằm trong module tương ứng: HKMockNetworkClient, HKMockRepository, HKMockViewModel. Không link target helper này vào app; nó phụ thuộc XCTest và có thể gây lỗi linker trong app target.

## Đọc tiếp

- [Trang tài liệu tổng](../../README.md)
- [Hướng dẫn DocC](../../Documentation/HydraKit.docc/Articles/Testing.md)
- [Tests của module](../../Tests/HydraKitTestingTests/)
