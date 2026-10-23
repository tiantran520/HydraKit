# HydraKitSecurity

## Cài đặt

Thêm product vào target sử dụng (xem [hướng dẫn cài package](../../README.md#cài-đặt)):

```swift
.product(name: "HydraKitSecurity", package: "HydraKit")
```

Module cung cấp contract auth và helper session/OAuth/biometric. App phải triển khai backend và nơi lưu token; module không có dịch vụ đăng nhập hoàn chỉnh mặc định.

## Token và SessionStore

Ví dụ store RAM cho demo/test, không persist qua lần mở app:

```swift
import Foundation
import HydraKitSecurity

actor MemorySessionStore: SessionStore {
    private var token: AuthToken?
    func save(_ token: AuthToken?) async throws { self.token = token }
    func load() async throws -> AuthToken? { token }
    func clear() async throws { token = nil }
}

func sessionExample() async throws -> AuthToken? {
    let manager = SessionManager(store: MemorySessionStore())
    let token = AuthToken(accessToken: "demo", expiresAt: Date().addingTimeInterval(3600))
    try await manager.start(with: token)
    let restored = try await manager.restore()
    try await manager.end()
    return restored
}
```

Với app thật, triển khai SessionStore bằng Keychain adapter trong app (HydraKitStorage có HKKeychainStore). `restore()` không validate expiration; caller kiểm tra `isExpired()`/refresh. currentToken chưa public để đọc trực tiếp. start/end đổi RAM trước khi persist: cần xử lý lỗi store trong app.

## Auth và refresh

`AuthService` yêu cầu signIn(username:password:), signOut(), refresh(token). Implementation gọi API riêng của app. `HKAuthState` chỉ mô tả unauthenticated/authenticating/authenticated/failed; app tự cập nhật và observe state.

`TokenRefreshHandler(refresh:)` nhận closure refresh. `validToken(from:leeway:)` refresh nếu còn không quá 60 giây theo mặc định; token không có expiresAt được trả nguyên. Helper không tự lưu token mới, không tự retry request 401 và không gộp các refresh đồng thời. Nối kết quả với SessionManager và tokenProvider của AuthInterceptor nếu dùng Network.

## OAuth2 và PKCE

```swift
let pkce = PKCE()
let state = HKSecureRandom.urlSafeString(length: 32)
let flow = OAuth2Flow(
    clientID: "your-client-id",
    authorizationURL: URL(string: "https://example.com/oauth/authorize")!,
    redirectURI: URL(string: "myapp://oauth/callback")!,
    scopes: ["profile"]
)
let url = flow.authorizationRequestURL(state: state, pkce: pkce)
```

Đây là builder URL, không mở browser hay exchange code. Giữ state và codeVerifier cho cùng lượt auth; app mở authentication session, kiểm tra callback/state, đổi code tại token endpoint với verifier rồi persist AuthToken. Cấu hình clientID/redirectURI theo backend. Xem [OAuth](OAuth/) để biết các tham số hỗ trợ.

## Biometric, inactivity và crypto

`BiometricAuth().biometricType()` nhận diện loại biometric; `authenticate(reason:)` chạy policy biometric và trả Bool hoặc ném lỗi từ platform. App tự bổ sung usage description/capability phù hợp và xử lý trường hợp không khả dụng hoặc người dùng hủy. Biometric helper không tự đăng nhập backend hay lưu credential.

`HKAutoLogoutHandler(timeout:onLogout:)` chỉ bắt đầu timer khi gọi reset. Gọi reset khi có hoạt động phù hợp, cancel khi kết thúc session, và giữ handler trong owner. Closure logout tự xóa session và cập nhật UI; gọi main actor khi thay state UI.

`CryptoService` chỉ là protocol encrypt/decrypt, chưa có cipher implementation. `HashService` và HKSecureRandom có helper hash/random; không phải cơ chế quản lý khóa. Xem [Crypto](Crypto/) trước khi tích hợp yêu cầu mã hóa của app.

## Đọc tiếp

- [Trang tài liệu tổng](../../README.md)
- [Hướng dẫn DocC](../../Documentation/HydraKit.docc/Articles/Security.md)
- [Tests của module](../../Tests/HydraKitSecurityTests/)
