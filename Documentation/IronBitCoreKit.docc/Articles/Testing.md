# Testing

Target `IronBitCoreKitTesting` cung cấp các helper cho unit test và preview.

## Thành Phần

- `MockLogger`, `MockDIContainer`.
- `Spy`, `Stub`, `Fake`.
- `SnapshotConfig`, `SnapshotHelper`.
- `XCTAssertEventually`, `XCTAssertNoThrowAsync`.

## Ví Dụ

```swift
let spy = Spy<String>()
spy.record("loaded")
XCTAssertEqual(spy.values, ["loaded"])
```

Các module Network/Repository/MVVM cũng có mock hoặc abstraction riêng để dễ test từng lớp.
