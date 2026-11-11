# OpenAPI

Sinh client theo contract backend với Swift OpenAPI Generator, tái dùng networking và token provider của HydraKit.

## Kiến trúc

`HydraKitOpenAPI.makeClient` nối generated `Client` → `HKOpenAPIAuthMiddleware` (nếu có provider) → `HKOpenAPIClientTransport` → `NetworkClient.data(for:)`.

Module mới là product tùy chọn. Không thêm OpenAPI vào các target cũ, không thay đổi `Endpoint`, `AuthInterceptor` hay DI container. Runtime và HTTPTypes cung cấp protocol/types; không dùng `swift-openapi-urlsession` và không tạo client thủ công song song.

Generated operations và DTO là public API của contract. Factory che chi tiết transport/middleware; không che các model và operations mà app cần sử dụng.

## Bắt đầu

Thêm product `HydraKitOpenAPI`, import Foundation, HydraKitOpenAPI và HydraKitNetwork khi cần tự cấu hình network:

```swift
import Foundation
import HydraKitNetwork
import HydraKitOpenAPI

func ping() async throws -> String {
    let mock = HKMockNetworkClient()
    mock.enqueue(try .json(["status": "ok"]))
    let client = HydraKitOpenAPI.makeClient(
        serverURL: URL(string: "https://example.com/api")!,
        networkClient: mock
    )
    let output = try await client.getPing()
    return try output.ok.body.json.status
}
```

Bỏ `networkClient` để dùng URLSession thật. `GET /ping` chỉ là placeholder. Trước production, thay `Sources/HydraKitOpenAPI/openapi.yaml` bằng spec backend trong checkout/fork và chỉnh `openapi-generator-config.yaml` nếu cần. Giữ generate types/client và accessModifier public. Build lại để sinh code; không chỉnh file generated trong build output. Đổi call site, smoke tests và ví dụ theo operation thật. Adapter không cần sửa.

## Authentication và transport

Factory nhận `@Sendable () async throws -> String?`, cùng kiểu với `AuthInterceptor`. App có thể dùng một closure truy cập session/refresh actor cho cả hai client. Middleware gọi closure mỗi operation, thêm Bearer token nếu không rỗng. Nil/rỗng giữ nguyên header, lỗi provider ngừng gửi request. Không tự refresh/retry 401, không tự chạy `HKInterceptorChain`.

Truyền `HKURLSessionNetworkClient` đã cấu hình để tái dùng retry/pinning/session. Các cache/ETag helper vẫn cần app wiring. Implementation `NetworkClient` tùy biến phải an toàn khi gọi đồng thời vì protocol cũ không yêu cầu Sendable.

Body được buffer, request giới hạn mặc định 16 MiB. Limit âm khiến `send` throw `HKOpenAPITransportError.invalidMaximumRequestBodyBytes`, không crash lúc init; limit 0 cho phép body rỗng; cấu hình giới hạn hoặc scheme khác bằng generated `Client(transport: HKOpenAPIClientTransport(...), middlewares: [...])`. Không hỗ trợ streaming/SSE. Xem [README module](../../../Sources/HydraKitOpenAPI/README.md) cho ví dụ cấu hình đầy đủ.

## Đăng ký DI (tùy chọn)

```swift
import HydraKit

func registerAPI(in container: HKDIContainer, network: any NetworkClient) {
    container.register((any APIProtocol).self) { _ in
        HydraKitOpenAPI.makeClient(
            serverURL: URL(string: "https://example.com/api")!,
            networkClient: network,
            tokenProvider: { "replace-with-session-token" }
        )
    }
}

func status(in container: HKDIContainer) async throws -> String {
    let api = container.resolve((any APIProtocol).self)
    let result = try await api.getPing(.init())
    return try result.ok.body.json.status
}
```

Gọi register trước resolve: thiếu registration vẫn là precondition failure theo hành vi DI hiện tại. Không có registration toàn cục tự động.

## Mapping và lỗi

Generated DTO thuộc module OpenAPI; không tái export vào domain/repository. App tự map output/model sang entity bằng DTOMapper hoặc adapter của app khi cần. Không đưa DTO backend vào module domain.

Transport bắt riêng `HKNetworkError.unacceptableStatus` từ URLSession client/mock và chuyển status/body về HTTPResponse/HTTPBody cho runtime. Generated client có thể trả output typed 4xx/5xx đúng contract; placeholder có thêm response 404 JSON và smoke test decode `output.notFound.body.json.message`.

Lỗi status cũ không lưu headers, nên response khôi phục không có Content-Type hoặc headers lỗi khác. Với contract có nhiều media type cho một status hoặc yêu cầu response headers, truyền custom NetworkClient trả raw Response<Data> cho non-2xx để giữ đủ metadata. Không đoán Content-Type. Retry vẫn diễn ra trong client cũ trước khi bridge nhận lỗi status cuối cùng.

Các lỗi network khác, cấu hình, decode, token và cancellation vẫn được runtime bọc thành `ClientError`; dùng `underlyingError` để phân loại. Retry của client cũ được giữ nguyên; chọn policy phù hợp cho thao tác ghi.

Đọc version bằng `HydraKitOpenAPI.version`; `HKHydraKitOpenAPI.version` là alias tương thích.

## Kiểm tra

```bash
swift build
swift test --filter HydraKitOpenAPITests
swift test
```

Tests cover URL prefix, encoded path/query, method, body, headers, status, giới hạn body, lỗi network/provider, token nil/rỗng và pipeline generated getPing qua factory/DI. Sau khi thay spec, sửa smoke tests theo contract thật. Generated artifacts và Package.resolved đang được gitignore theo convention repo.

Dependencies dùng version range của kế hoạch; SwiftPM chọn version phù hợp toolchain. Phiên bản dependency mới có thể cần Swift mới hơn. Kết quả kiểm chứng của lần tích hợp này dùng Swift 6.4 ở language mode Swift 5; chưa xác minh trực tiếp trên toolchain Swift 5.10.
