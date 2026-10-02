# Dependency Injection

HydraKit cung cấp `HKDIContainer`, `Resolver` và property wrapper `Injected` trong target `HydraKit`.

## Mẫu Sử Dụng

```swift
let container = HKDIContainer()
container.register(Logger.self) { OSLogLogger() }
let logger = try container.resolve(Logger.self)
```

## Khuyến Nghị

- Đăng ký protocol thay vì concrete type.
- Tạo container ở composition root của app.
- Trong test, thay implementation thật bằng mock từ `HydraKitTesting`.
