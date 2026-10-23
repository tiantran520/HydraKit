# HydraKitRepository

## Cài đặt

Thêm product vào target sử dụng (xem [hướng dẫn cài package](../../README.md#cài-đặt)):

```swift
.product(name: "HydraKitRepository", package: "HydraKit")
```

Repository tách cách đọc/ghi dữ liệu khỏi ViewModel. Chọn capability tối thiểu: `Readable`, `Writable`, `Streamable`; `Repository` kết hợp cả ba.

## Dùng mock trước khi có backend

```swift
import Foundation
import HydraKitRepository

struct Note: Codable, Sendable {
    let id: Int
    let title: String
}

func example() async throws -> [Note] {
    let repository = HKMockRepository<Int, Note>(idProvider: { $0.id })
    try await repository.save(Note(id: 1, title: "Ghi chú"))
    return try await repository.readAll()
}
```

Mock lưu trong RAM, `read(id:)` trả nil nếu thiếu. Thứ tự `readAll()` không được đảm bảo. ID của seed values phải duy nhất.

## Local repository

```swift
import HydraKitStorage

func localExample() async throws -> Note? {
    let repository = HKLocalRepository<Int, Note>(
        store: HKUserDefaultsStore(),
        keyProvider: { StorageKey<Note>("notes.v1.\($0)") },
        allKeysProvider: { [1] }
    )
    try await repository.save(Note(id: 1, title: "Offline"), id: 1)
    return try await repository.read(id: 1)
}
```

Dùng `save(_:id:)`; `save(_:)` của local repository luôn ném unsupportedOperation. `allKeysProvider` do app quản lý, không tự phát hiện key mới. Không truyền provider thì `readAll()` trả mảng rỗng và snapshot stream sau ghi cũng rỗng.

## Network repository và DTO

`HKNetworkRepository<ID, Mapper>` nhận client, mapper và `readEndpoint`; cấu hình thêm readAllEndpoint/saveEndpoint/deleteEndpoint khi cần. Mapper conform `DTOMapper`, cung cấp `mapToModel` và `mapToDTO`, DTO phải Codable & Sendable. Domain model không bắt buộc Codable ở repository network.

API đọc một item decode một DTO, đọc tất cả decode `[DTO]`. Nếu server có envelope như `{ "items": [...] }`, cần adapter phù hợp thay vì truyền endpoint trực tiếp và mong thư viện tự unwrap. Thiếu endpoint tùy chọn ném unsupportedOperation. HTTP 404 hiện thành networkFailed, không tự chuyển về nil. Decoder mặc định ở repository là `.ironBitDefault()`.

## Hybrid và chiến lược đọc

`HKHybridRepository` nhận local repository, strategy, idProvider và closure networkRead. Model cần Codable & Sendable.

| Strategy | Hành vi `read(id:)` |
| --- | --- |
| `CacheFirstStrategy` | Có local thì trả ngay; local nil mới gọi network và lưu local |
| `NetworkFirstStrategy` | Gọi network, lưu local; lỗi trong network hoặc lưu local thì đọc local |

Cache-first không kiểm tra TTL và không refresh nền. Network-first nhận nil từ network thì trả nil, không fallback local; catch hiện bao gồm cancellation, nên tự viết strategy nếu cần truyền cancellation lên caller.

`readAll()` của hybrid luôn đọc network rồi lưu từng model vào local, không áp dụng strategy và không xóa item local vắng trong response. `save`/`delete` chạy remote trước local, không có transaction hay rollback. Các closure networkReadAll/networkSave/networkDelete mặc định trả rỗng hoặc không làm gì: phải cung cấp nếu cần hành vi thật.

## Stream và lỗi

`stream()` của local/mock/hybrid phát snapshot sau save/delete, không phát seed snapshot ngay khi subscribe. Gọi `readAll()` cho trạng thái đầu. Implementation dùng một AsyncStream chung, không phải broadcast riêng cho từng subscriber; cần tự thiết kế fan-out khi có nhiều consumer. Stream không tự theo dõi ghi trực tiếp vào store bên ngoài repository.

`HKRepositoryError` có notFound, mappingFailed, networkFailed, localFailed, unsupportedOperation; không phải tất cả implementation đều tự map mọi lỗi vào enum này. Local store có thể truyền lỗi storage lên trực tiếp.

## Đọc tiếp

- [Trang tài liệu tổng](../../README.md)
- [Hướng dẫn DocC](../../Documentation/HydraKit.docc/Articles/Repositories.md)
- [Tests của module](../../Tests/HydraKitRepositoryTests/)
