# HydraKitAnalytics: hướng dẫn sử dụng

Module tách analytics khỏi SDK nhà cung cấp. Bạn triển khai AnalyticsProvider và truyền vào EventTracker; chưa có adapter backend mặc định.

## Provider và tracking

Ví dụ provider chỉ ghi trong RAM để kiểm thử:

```swift
import HydraKitAnalytics

actor RecordingProvider: AnalyticsProvider {
    private(set) var events: [AnalyticsEvent] = []
    func track(_ event: AnalyticsEvent) async { events.append(event) }
    func identify(userID: String?) async {}
    func setUserProperties(_ properties: EventProperties) async {}
}

func trackExample() async {
    let provider = RecordingProvider()
    let tracker = EventTracker(providers: [provider])
    await tracker.identify(userID: "user-42")
    await tracker.track(AnalyticsEvent(
        name: "note_created", properties: ["source": "home", "count": "1"]
    ))
    await ScreenTracker(analytics: tracker).track("Notes")
    await tracker.identify(userID: nil)
}
```

EventTracker gửi đến các provider đồng thời và chờ hoàn tất; mảng provider rỗng không gửi gì. EventProperties chỉ chứa `[String: String]`, nên số/bool phải chuyển String. App quyết định tên event thống nhất và thời điểm track.

ScreenTracker tạo event screen_view. ScreenView thêm screen_name nhưng giữ giá trị đã có trong properties; không truyền screen_name khác với tên screen nếu muốn dữ liệu nhất quán. Facade chưa có setUserProperties; gọi trực tiếp provider hoặc bổ sung service adapter của app.

## Feature flag và remote config

`FeatureFlag(key:defaultValue:)` là định nghĩa; `FeatureFlagProvider` chỉ là protocol `isEnabled`. `RemoteConfigService` yêu cầu fetch/value, chưa có transport, cache hoặc refresh scheduler. App triển khai và quyết định fallback.

`HKConfigValue` có string/bool/int/double/none. `.stringValue` và `.boolValue` chỉ lấy đúng case, không tự chuyển String thành Bool. Với int/double, dùng switch. Sau fetch thất bại, giữ cấu hình đã biết hoặc default theo chính sách của app.

## A/B testing

`VariantAssigner().assign(userID:experiment:)` chọn variant trong Experiment, trả nil khi variants rỗng. Implementation dùng Swift hashValue, chỉ ổn định trong cùng process; assignment có thể đổi giữa các lần chạy. Nếu cần cohort ổn định, dùng hash ổn định hoặc assignment do backend cung cấp và persist kết quả.

## Performance và crash

```swift
let monitor = PerformanceMonitor()
await monitor.start("load_notes")
// Thực hiện tác vụ cần đo tại đây.
let seconds = await monitor.stop("load_notes")
```

stop trả nil nếu chưa start, start lại cùng tên thay mốc trước. Helper chỉ đo thời gian, không tự gửi metric; app tạo event/property nếu cần.

`CrashReporter` là adapter do app triển khai; `NonFatalErrorLogger` chuyển lỗi và EventProperties cho reporter. `MetricKitIntegration` là điểm tích hợp protocol, chưa đăng ký subscriber MetricKit. Không giả định module tự thu thập crash hay metric.

## Kiểm thử

Inject RecordingProvider và assert events sau await track. Test flags/config bằng provider riêng trả giá trị định trước. Tách tracking khỏi UI giúp kiểm thử event mà không cần chạy SDK bên ngoài.
