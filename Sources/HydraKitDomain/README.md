# HydraKitDomain

## Cài đặt

Thêm product vào target sử dụng (xem [hướng dẫn cài package](../../README.md#cài-đặt)):

```swift
.product(name: "HydraKitDomain", package: "HydraKit")
```

Đặt entity, dữ liệu đã validate và use case tại lớp nghiệp vụ. Module phụ thuộc core, không phụ thuộc Network, Storage hoặc SwiftUI.

## Entity và value object

```swift
import Foundation
import HydraKitDomain

func makeUser(emailText: String) throws -> User {
    let email = try Email(emailText)
    return User(name: "An", email: email)
}
```

`Entity` yêu cầu ID Hashable & Sendable. Extension cung cấp equality/hash theo ID; khi tự triển khai hoặc để compiler synthesize Hashable cho model riêng, hãy kiểm tra semantics mong muốn. `ValueObject` yêu cầu Hashable, Codable, Sendable; dùng cho giá trị được xác định bởi nội dung.

`Email(String)` trim khoảng trắng và kiểm tra format; `PhoneNumber(String)` kiểm tra format cơ bản. String literal của hai type **không validate**, nên dữ liệu nhập từ người dùng phải đi qua initializer throwing. `URL.valueObject(_:)` chỉ yêu cầu URL có scheme, không giới hạn HTTP/HTTPS. Các kiểm tra này không xác thực sự tồn tại của email/số điện thoại.

## Viết use case

```swift
struct CreateUser: UseCase {
    struct Input: Sendable {
        let name: String
        let email: String
    }

    func execute(_ input: Input) async throws -> User {
        guard !input.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw HKUseCaseError.invalidInput("Tên không được rỗng")
        }
        return User(name: input.name, email: try Email(input.email))
    }
}

func example() async throws -> User {
    let useCase = AnyUseCase(CreateUser())
    return try await useCase.execute(.init(name: "An", email: "an@example.com"))
}
```

Để truy cập repository, định nghĩa protocol nghiệp vụ trong app/domain riêng và truyền implementation vào initializer. `AnyUseCase` xóa type cụ thể để ViewModel chỉ giữ Input/Output; closure và dữ liệu cần Sendable.

## Session và lỗi

`Session` là entity ví dụ chứa userID, accessToken, createdAt và expiresAt; `isExpired` false khi không có ngày hết hạn. Nó không phải `AuthToken` hoặc `SessionManager` trong Security, và không tự lưu token.

- `HKValidationError`: dữ liệu đầu vào không đúng định dạng.
- `HKDomainError`: lỗi nghiệp vụ; xem [Errors](Errors/).
- `HKUseCaseError`: invalidInput, domain, cancelled, unexpected.

UseCase không tự chuyển mọi lỗi thành `HKUseCaseError`. Implementation của app chịu trách nhiệm map lỗi khi cần, và giữ cancellation đúng với luồng gọi.

## Đọc tiếp

- [Trang tài liệu tổng](../../README.md)
- [Hướng dẫn DocC](../../Documentation/HydraKit.docc/Articles/Domain.md)
- [Tests của module](../../Tests/HydraKitDomainTests/)
