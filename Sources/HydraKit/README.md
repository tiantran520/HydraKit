# HydraKit

## Cài đặt

Thêm product vào target sử dụng (xem [hướng dẫn cài package](../../README.md#cài-đặt)):

```swift
.product(name: "HydraKit", package: "HydraKit")
```

Core dùng cho DI, logging, xử lý lỗi và tiện ích. Chọn module này khi muốn chia sẻ service giữa các lớp mà không phụ thuộc UI.

## Dependency injection

```swift
import HydraKit

let container = HKDIContainer()
container.register(Logger.self, service: OSLogLogger(subsystem: "MyApp"))
let logger: any Logger = container.resolve(Logger.self)
logger.info("App đã khởi động")
```

`register(_:service:)` trả lại cùng instance. Factory `register { resolver in ... }` chạy mỗi lần resolve; container không tự cache instance:

```swift
container.register(Logger.self) { _ in OSLogLogger(subsystem: "MyApp") }
```

Đăng ký tại composition root trước khi dựng ViewModel. Thiếu đăng ký gây `preconditionFailure`, không phải lỗi có thể bắt bằng `do/catch`. Đăng ký lại cùng type sẽ thay factory cũ; `removeAll()` xóa toàn bộ đăng ký. Tránh dependency vòng vì resolve sẽ gọi đệ quy.

`@Injected` mặc định dùng container shared, và resolve mỗi lần đọc property:

```swift
HKDIContainer.shared.register(Logger.self, service: OSLogLogger())

struct StartupService {
    @Injected var logger: any Logger
    func start() { logger.info("Khởi động") }
}
```

Để cô lập test, ưu tiên truyền dependency bằng initializer hoặc dùng `@Injected(resolver: container)` với container riêng.

## Logging và lỗi

Dùng `trace`, `debug`, `info`, `warning`, `error` với category `.general`, `.network`, `.storage`, `.ui`. `log` hỗ trợ metadata và level `.critical`. `OSLogLogger` xuất thông điệp với privacy public; chỉ truyền nội dung phù hợp để xuất log.

`AppError` là contract cho lỗi của app (`code`, `title`, `message`, `underlyingError`). `ErrorMapper<YourError>` chuyển lỗi hạ tầng sang lỗi app. `ErrorPresenter().presentation(for:)` tạo `ErrorPresentation` để view hiển thị; lỗi thường dùng title "Error" và `localizedDescription`.

## Debounce, throttle và concurrency

```swift
let debouncer = HKDebouncer(delay: 0.3)
debouncer.schedule { print("Chỉ chạy sau khi ngừng nhập 300 ms") }
// Khi đóng màn hình:
debouncer.cancel()

let throttler = HKThrottler(interval: 1)
throttler.run { print("Giới hạn tần suất thao tác") }
throttler.cancel()
```

Giữ các instance trên trong owner có vòng đời đủ dài. Debouncer thay công việc đang chờ; throttler thay công việc đang chờ và tính khoảng cách từ lần chạy gần nhất. Mặc định chạy closure trên main queue; nên gọi nhất quán từ cùng luồng.

`Task.sleep(seconds:)` và `Task.delayed(seconds:operation:)` hỗ trợ delay có cancellation. `AsyncSequence.collect()` chờ đến khi stream kết thúc, vì vậy không dùng để lấy một snapshot từ stream sống lâu. `first(where:)` dừng ở phần tử đầu khớp predicate. `performInIsolation` giúp thực hiện công việc trong actor.

## Tiện ích khác

| Nhóm | Cách dùng |
| --- | --- |
| `HKWeak` | Giữ tham chiếu yếu đến class, đọc qua `.value` |
| `Result` | `.value`, `.error`, `.optional()` để truy cập kết quả |
| Extensions | Xem [Extensions](Extensions/) cho String, Date, Optional, Array, Bundle, View |

## Khi gặp lỗi

- Crash "No dependency registered": kiểm tra type đăng ký và container mà `Injected` đang dùng.
- Service bị tạo nhiều lần: dùng `register(_:service:)` nếu cần dùng chung instance.
- Debounce không cập nhật UI: kiểm tra owner và queue; UI cần cập nhật trên main actor.

## Đọc tiếp

- [Trang tài liệu tổng](../../README.md)
- [Hướng dẫn DocC](../../Documentation/HydraKit.docc/Articles/DependencyInjection.md)
- [Tests của module](../../Tests/HydraKitTests/)
