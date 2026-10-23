# HydraKitStorage

## Cài đặt

Thêm product vào target sử dụng (xem [hướng dẫn cài package](../../README.md#cài-đặt)):

```swift
.product(name: "HydraKitStorage", package: "HydraKit")
```

Chọn nơi lưu theo dữ liệu: UserDefaults cho thiết lập nhỏ, Keychain cho Data bí mật, file cho JSON/tệp và database cho dữ liệu có schema.

## Key-value với key có kiểu

```swift
import Foundation
import HydraKitStorage

func savePreference() async throws -> Bool {
    let store = HKUserDefaultsStore()
    let key = StorageKey<Bool>("settings.notifications.v1")
    try await store.setValue(true, for: key)
    return try await store.value(for: key) ?? false
}
```

Value phải Codable & Sendable. Key vắng trả nil; ghi nil xóa giá trị. `contains` nhận raw String. Dùng namespace và version cho key khi thay schema. Đổi kiểu Codable trên cùng key có thể gây lỗi decode.

Store encode JSON thành Data, không tương đương `UserDefaults.bool(forKey:)`. `removeAll()` dùng bundle identifier để xóa persistent domain; với UserDefaults suite tùy chỉnh nên tự quản lý việc xóa domain của suite, không giả định helper sẽ xóa suite đó.

## Keychain

```swift
func saveToken(_ token: String) throws {
    let store = HKKeychainStore()
    let item = KeychainItem(
        service: "com.example.app.auth",
        account: "access-token",
        accessibility: .whenUnlockedThisDeviceOnly
    )
    try store.setData(Data(token.utf8), for: item)
    let data = try store.data(for: item)
    _ = data.flatMap { String(data: $0, encoding: .utf8) }
    // Khi logout: try store.removeData(for: item)
}
```

Đọc key chưa có trả nil. Giữ service/account nhất quán khi đọc và xóa. Keychain API đồng bộ, không conform `KeyValueStore`; dùng adapter riêng nếu cần `SessionStore`.

## File và JSON

```swift
func saveDraft() throws -> [String] {
    let files = HKFileStore(location: .temporary)
    let json = HKJSONFileStore(fileStore: files)
    try json.write(["Bản nháp"], to: "hydrakit-example/draft.json")
    return try json.value([String].self, at: "hydrakit-example/draft.json")
}
```

Dùng `.documents` cho dữ liệu người dùng, `.caches` cho dữ liệu có thể tải lại, `.temporary` cho dữ liệu tạm hoặc `.custom(URL)` cho thư mục riêng. FileStore ghi atomic và tạo thư mục cha. JSON store không conform `KeyValueStore`; đọc file thiếu ném lỗi, không trả nil. Path nên do app kiểm soát.

## Cache

`HKLRUCache<Key, Value>(capacity:)` là cache RAM đồng bộ; `setValue(_:for:expiresAt:)` hỗ trợ hết hạn và loại item ít dùng nhất khi đầy. Capacity tối thiểu 1.

`HKUnifiedCache<Value>(memoryCapacity:persistentStore:)` đọc RAM rồi persistent store, và đẩy dữ liệu đọc được vào RAM. Dùng cùng `StorageKey<Value>` như key-value store. Không có TTL cho persistent layer; tự thiết kế invalidation nếu dữ liệu cần freshness. Ghi RAM diễn ra trước ghi persistent: lỗi ghi đĩa có thể để RAM và persistent khác nhau.

## SwiftData và Core Data

- SwiftData: tạo Schema và `ModelContainer.ironBitDefault(for:isStoredInMemoryOnly:)`, bọc bằng `HKSwiftDataStack`, truyền ModelContext vào `HKSwiftDataStore<Model>`. Model của app cần `@Model` và PersistentModel.
- Core Data: tạo NSPersistentContainer với model của app, truyền vào `HKCoreDataStack`, `try await loadPersistentStores()`, lấy context để tạo `HKCoreDataStore<Model>`.
- Cả hai store có `insert`, `delete`, `save`; sau thay đổi gọi `save()` để persist. Fetch/query dùng context gốc, vì `DatabaseStore` chưa cung cấp read API.
- Giữ thao tác SwiftData trên executor phù hợp với ModelContext; `@unchecked Sendable` không tự bảo vệ context khỏi truy cập đồng thời.

## Khi gặp lỗi

`HKStorageError` phân biệt encode/decode/operation/invalidKey. Với lỗi decode sau nâng cấp schema, thực hiện migration hoặc xóa riêng dữ liệu có thể tạo lại. Không dùng xóa toàn bộ dữ liệu như cách xử lý mặc định.

## Đọc tiếp

- [Trang tài liệu tổng](../../README.md)
- [Hướng dẫn DocC](../../Documentation/HydraKit.docc/Articles/Storage.md)
- [Tests của module](../../Tests/HydraKitStorageTests/)
