# HydraKitOpenAPI

Client được sinh từ OpenAPI, gửi request qua `HydraKitNetwork`. Chỉ target này dùng plugin; các target cũ không phụ thuộc OpenAPI. SwiftPM vẫn cần resolve dependencies của package.

**Contract đi kèm chỉ là placeholder `GET /ping`. Thay contract thật trước khi dùng production.**

## Cài đặt và gọi thử

Thêm product vào target app:

```swift
.product(name: "HydraKitOpenAPI", package: "HydraKit")
```

Ví dụ không cần server:

```swift
import Foundation
import HydraKitNetwork
import HydraKitOpenAPI

func checkPing() async throws -> String {
    let network = HKMockNetworkClient()
    network.enqueue(try .json(["status": "ok"]))
    let client = HydraKitOpenAPI.makeClient(
        serverURL: URL(string: "https://example.com/api/v1")!,
        networkClient: network,
        tokenProvider: { "demo-token" }
    )
    let output = try await client.getPing()
    return try output.ok.body.json.status
}
```

Để gọi server thật, bỏ `networkClient` để dùng `HKURLSessionNetworkClient()` hoặc truyền client đã cấu hình session/pinning/retry của app. `serverURL` có thể có path prefix: `/api/v1` kết hợp `/ping` thành `/api/v1/ping`. Không đặt query/fragment trong server URL; query lấy từ operation.

## Thay contract backend

1. Sửa trong checkout/fork của HydraKit (không sửa bản cache read-only của Xcode).
2. Thay `Sources/HydraKitOpenAPI/openapi.yaml` bằng spec backend. Dùng operationId ổn định để API Swift dễ đọc.
3. Giữ `generate: [types, client]` và `accessModifier: public` trong `openapi-generator-config.yaml`; chỉnh filter/naming nếu backend cần.
4. Chạy `swift build`. Plugin sinh `Types.swift` và `Client.swift` trong thư mục build; không sửa hay commit file generated.
5. Cập nhật call site và `HydraKitOpenAPISmokeTests` theo operation/model thật, thay các ví dụ `/ping` tương ứng; chạy `swift test`.

Transport/auth/factory không phụ thuộc `/ping`, nên không cần đổi adapter khi thay spec. Generated `Client`, `APIProtocol`, `Operations`, `Components` là public API của contract: tên operation và DTO có thể đổi theo spec. Các chi tiết wiring được factory che đi; generated API không phải private API.

Một binary HydraKitOpenAPI chứa một contract lúc build; không nạp YAML động từ app. Cần nhiều backend với nhiều contract thì tạo target generated riêng và tái dùng transport/middleware public.

## Dùng chung token với network cũ

```swift
let tokenProvider: @Sendable () async throws -> String? = {
    // Lấy token từ actor/session của app; có thể refresh trước khi trả về.
    return "current-access-token"
}
let oldAuth = AuthInterceptor(tokenProvider: tokenProvider)
let client = HydraKitOpenAPI.makeClient(
    serverURL: URL(string: "https://example.com")!,
    tokenProvider: tokenProvider
)
```

Provider được gọi cho mỗi operation. Nil hoặc chuỗi rỗng giữ nguyên Authorization, token có giá trị thay header bằng `Bearer <token>`. Không tự refresh token hay retry 401. App chịu trách nhiệm nối `SessionManager`/`TokenRefreshHandler` trong closure. `oldAuth` vẫn cần được app nối vào chain như trước.

Scheme khác hoặc middleware bổ sung: tạo generated `Client` trực tiếp:

```swift
let client = Client(
    serverURL: URL(string: "https://example.com")!,
    transport: HKOpenAPIClientTransport(
        networkClient: HKURLSessionNetworkClient(retryPolicy: .never),
        maximumRequestBodyBytes: 32 * 1024 * 1024
    ),
    middlewares: [HKOpenAPIAuthMiddleware(scheme: "Token", tokenProvider: tokenProvider)]
)
```

## Hành vi và giới hạn

- Transport chuyển method, path/query đã encode, headers và body sang URLRequest; giữ response status/headers/body. Không tự chạy interceptor chain, cache hay ETag. Pinning/session/retry chỉ có khi network client được truyền vào đã cấu hình chúng.
- `NetworkClient` không yêu cầu `Sendable`. Transport dùng `@unchecked Sendable`; caller phải truyền implementation an toàn khi gọi đồng thời. Không dùng client chứa mutable state không được bảo vệ.
- Request body được buffer thành Data, mặc định tối đa 16 MiB; vượt giới hạn sẽ throw trước khi gửi. Limit âm không gây crash lúc init: `send` ném `HKOpenAPITransportError.invalidMaximumRequestBodyBytes`, kể cả request không có body; limit 0 cho phép body rỗng. Response cũng dùng Data theo client hiện tại. Chưa hỗ trợ streaming/SSE hoặc upload/download vô hạn.
- `HKURLSessionNetworkClient` và mock ném `HKNetworkError.unacceptableStatus` cho non-2xx. Bridge bắt riêng lỗi này, trả status/body về runtime để decode nhánh output tương ứng trong contract (ví dụ `output.notFound`). Không thay đổi hành vi client cũ; retry vẫn hoàn tất trong network client trước khi bridge nhận kết quả.
- `unacceptableStatus` chỉ giữ status/body, không giữ headers: response được khôi phục sẽ không có Content-Type, Retry-After hay header lỗi khác. Nếu contract có nhiều media type cho cùng status hoặc bắt buộc response headers, truyền `NetworkClient` trả raw `Response<Data>` cho non-2xx để giữ đủ metadata; bridge không đoán Content-Type.
- Retry mặc định được giữ nguyên và có thể retry cả request ghi dữ liệu. Chọn `.never` hoặc policy phù hợp với API có side effect.
- Headers phản hồi được giới hạn bởi `HTTPHeaders` hiện có (dictionary, không giữ được nhiều Set-Cookie riêng biệt). Tên header không hợp lệ trong response tùy biến bị bỏ qua.

## Lỗi khi gọi generated operation

Non-2xx là output HTTP, không tự trở thành lỗi transport. Contract placeholder có nhánh 404 JSON để kiểm tra decode. Các lỗi transport, cấu hình, decode, token và cancellation vẫn được runtime bọc trong `OpenAPIRuntime.ClientError`; đọc `underlyingError`:

```swift
import OpenAPIRuntime

func loadStatus(client: Client) async throws -> String {
    do {
        let output = try await client.getPing()
        if case .notFound = output {
            return try output.notFound.body.json.message
        }
        return try output.ok.body.json.status
    } catch let error as ClientError {
        if let networkError = error.underlyingError as? HKNetworkError {
            // Map lỗi transport của HydraKit theo nhu cầu app.
            throw networkError
        }
        // underlyingError cũng có thể là CancellationError hoặc lỗi tokenProvider.
        throw error
    }
}
```

Nếu app trực tiếp import `OpenAPIRuntime`, nên khai báo thêm product runtime trong manifest của app. Khi gọi transport trực tiếp, các lỗi `HKNetworkError` ngoài `unacceptableStatus` được ném nguyên trạng.

Xem thêm [DocC OpenAPI](../../Documentation/HydraKit.docc/Articles/OpenAPI.md) cho DI, mapping và kiểm thử.

## Version

Đọc `HydraKitOpenAPI.version`. `HKHydraKitOpenAPI.version` là alias tương thích, cùng giá trị.
