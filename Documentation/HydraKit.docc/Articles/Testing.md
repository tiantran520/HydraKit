# Testing

Target `HydraKitTesting` cung cấp các helper cho unit test và preview.

## Thành Phần

- `HKMockLogger`, `HKMockDIContainer`.
- `HKSpy`, `HKStub`, `HKFake`.
- `SnapshotConfig`, `HKSnapshotHelper`.
- `XCTAssertEventually`, `XCTAssertNoThrowAsync`.

## Ví Dụ

```swift
let spy = HKSpy<String>()
spy.record("loaded")
XCTAssertEqual(spy.values, ["loaded"])
```

Các module Network/Repository/MVVM cũng có mock hoặc abstraction riêng để dễ test từng lớp.
