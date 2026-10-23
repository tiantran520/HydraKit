# HydraKitNetwork: hướng dẫn sử dụng

Module gọi HTTP bằng async/await, mô tả endpoint, decode JSON, retry và mock. Import Foundation khi dùng URL, Data hoặc URLRequest.

## Gọi endpoint và decode

Ví dụ chạy không cần server:

```swift
import Foundation
import HydraKitNetwork

struct Todo: Codable, Sendable {
    let id: Int
    let title: String
}

struct TodosEndpoint: Endpoint {
    let baseURL = URL(string: "https://example.com")!
    let path = "todos"
    var queryItems: [URLQueryItem] { [URLQueryItem(name: "page", value: "1")] }
}

func loadTodos() async throws -> [Todo] {
    let client = HKMockNetworkClient()
    client.enqueue(try StubResponse.json([Todo(id: 1, title: "Đọc docs")]))
    let response: Response<[Todo]> = try await client.send(TodosEndpoint())
    return response.value
}
```

Đổi client thành `HKURLSessionNetworkClient()` để gọi server thật. Thay `baseURL` bằng server của app. `Response` giữ value, status, headers và URL. Với response rỗng (ví dụ 204), dùng `data(for:)` thay vì decode một model JSON.

## Cấu hình request

`Endpoint` chỉ bắt buộc `baseURL`, `path`; mặc định GET, headers/query rỗng, body nil, timeout 60 giây, cache policy `.useProtocolCachePolicy`. Override `method`, `headers`, `body` để gửi POST. Encode body bằng `JSONEncoder` và đặt `Content-Type: application/json`. `RequestBuilder().buildRequest(for:)` nối path và tạo URLRequest; queryItems sẽ thay query trên URL khi không rỗng.

`send` mặc định dùng `JSONDecoder()` thông thường. Truyền decoder phù hợp API; `.ironBitDefault()` dùng cấu hình của thư viện, xem [Decoding](../../../Sources/HydraKitNetwork/Decoding/).

## Nối interceptor vào request

Client URLSession không tự chạy chain. Áp dụng chain trước khi gửi và sau khi nhận:

```swift
func loadRaw() async throws -> Response<Data> {
    let client = HKURLSessionNetworkClient()
    let chain = HKInterceptorChain(requestInterceptors: [
        HeaderInterceptor(headers: ["Accept": "application/json"])
    ])
    let original = try RequestBuilder().buildRequest(for: TodosEndpoint())
    let request = try await chain.intercept(original)
    let response = try await client.data(for: request)
    return try await chain.intercept(response)
}
```

Thêm `AuthInterceptor { ... }` để lấy token bất đồng bộ. Token nil/rỗng giữ nguyên request. Chain chạy theo thứ tự đăng ký; thêm lại cùng ID thay interceptor cũ và đưa xuống cuối. `LoggingInterceptor` hỗ trợ log; xem nội dung thực tế trước khi chọn dữ liệu đưa vào log.

## Retry và hủy

```swift
let client = HKURLSessionNetworkClient(retryPolicy: .never)
```

Policy mặc định tối đa 3 lần tính cả lần đầu, exponential backoff 0.3 giây, multiplier 2, cap 5 giây, retry status 500–599 và một số URLError. Không retry lỗi decode hoặc cancellation. Policy không phân biệt HTTP method: với thao tác tạo/thanh toán cần chọn policy theo tính chất request để tránh thực hiện lặp.

`requestTask(for:)` trả `HKRequestTask`; gọi `cancel()` khi owner không cần kết quả nữa. Task cancellation được kiểm tra trước mỗi attempt.

## Cache, ETag, reachability và pinning

| Nhóm | Tích hợp |
| --- | --- |
| `HKMemoryCache`, `HKDiskCache` | Đọc/ghi Data qua `NetworkCache`; app tự chọn key và thời điểm gọi |
| `HKETagHandler` | Gọi `applyETag` trước request, `storeETag` sau response |
| `HKNetworkMonitor` | Theo dõi connection; xem [Reachability](../../../Sources/HydraKitNetwork/Reachability/) |
| Certificate pinning | Tạo delegate/session theo [Security](../../../Sources/HydraKitNetwork/Security/), truyền session vào client |
| `TimeoutConfiguration` | Xem [Transport](../../../Sources/HydraKitNetwork/Transport/); endpoint có timeout riêng |

Các helper cache/ETag không tự được client sử dụng. Client chỉ chấp nhận HTTP 2xx; 304 bị trả thành `unacceptableStatus`. Muốn revalidation ETag phải tự xử lý nhánh này và trả body cache.

## Kiểm thử và xử lý lỗi

`HKMockNetworkClient` lấy kết quả FIFO, ghi request vào `requests`; hết stub ném `.invalidResponse`. Dùng `enqueue(error)` cho nhánh thất bại và `NetworkDelaySimulator` cho loading/cancellation. Mock không thực hiện retry của URLSession client.

Bắt `HKNetworkError`: `.invalidURL`, `.invalidResponse`, `.unacceptableStatus`, `.transportFailed`, `.decodingFailed`. Với `.unacceptableStatus`, inspect status và body để map lỗi server. Bắt `CancellationError` riêng để tránh hiện cảnh báo khi người dùng rời màn hình.
