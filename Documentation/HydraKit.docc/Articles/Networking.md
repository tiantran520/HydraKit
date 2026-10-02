# Networking

Target `HydraKitNetwork` cung cấp core networking dựa trên async/await.

## Thành Phần

- `Endpoint`: mô tả endpoint.
- `RequestBuilder`: chuyển endpoint thành `URLRequest`.
- `NetworkClient`: protocol cho client.
- `HKURLSessionNetworkClient`: implementation dùng URLSession, retry và cancellation.
- `HKInterceptorChain`: request/response interceptor runtime.
- `NetworkCache`: memory/disk cache abstraction.

## Ví Dụ

```swift
let client = HKURLSessionNetworkClient()
let request = URLRequest(url: URL(string: "https://example.com")!)
let response: Response<Data> = try await client.data(for: request)
```
