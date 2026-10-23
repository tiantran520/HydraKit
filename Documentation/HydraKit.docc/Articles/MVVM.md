# HydraKitMVVM: hướng dẫn sử dụng

Dùng ViewAction mô tả thao tác từ view, ViewModel điều phối use case và HKViewState biểu diễn trạng thái tải. Các ViewModel/state container của module hoạt động trên main actor.

## ViewModel có loading, error và cancellation

```swift
import Foundation
import SwiftUI
import HydraKitMVVM

enum NotesAction: ViewAction { case load }

@MainActor
final class NotesViewModel: HKBaseViewModel<NotesAction> {
    let state = HKStateContainer<[String]>()

    override func send(_ action: NotesAction) {
        cancelTasks()
        state.setState(.loading)
        let task = Task { [weak self] in
            do {
                try await Task.sleep(for: .milliseconds(200))
                try Task.checkCancellation()
                self?.state.setLoaded(["Ghi chú đầu tiên"])
            } catch is CancellationError {
                self?.state.setState(.idle)
            } catch {
                self?.state.setError(error)
            }
        }
        store(HKCancellableTask(task))
    }
}

@MainActor
struct NotesContent: View {
    @ObservedObject var state: HKStateContainer<[String]>

    var body: some View {
        switch state.state {
        case .idle: Text("Chưa tải")
        case .loading: ProgressView()
        case let .loaded(notes): List(notes, id: \.self) { Text($0) }
        case let .error(error): Text(error.localizedDescription)
        }
    }
}

@MainActor
struct NotesScreen: View {
    @StateObject private var model = NotesViewModel()

    var body: some View {
        NotesContent(state: model.state)
            .onAppear { model.send(.load) }
            .onDisappear { model.cancelTasks() }
    }
}
```

Thay delay bằng use case được inject trong app. View phải observe `HKStateContainer` trực tiếp như `NotesContent`: observe ViewModel không tự chuyển tiếp thay đổi từ observable object con. `HKBaseViewModel` chỉ quản lý task, không cung cấp state tự động.

`HKViewState` có idle/loading/loaded/error; mảng rỗng vẫn là loaded. Nếu dùng `HydraKitUI.ContentStateView`, tự map sang `HKContentState`, kể cả nhánh empty; hai enum không thay thế trực tiếp cho nhau.

## Vòng đời task

`store(_:)` lưu HKCancellableTask; `cancelTasks()` hủy toàn bộ rồi bỏ danh sách, deinit cũng hủy. Task hoàn tất chưa tự bị loại khỏi danh sách. Cancellation phải được operation tuân thủ; tránh capture self mạnh suốt task sống lâu. Với nhiều lần load chồng nhau, app cần chống kết quả cũ ghi đè kết quả mới (ví dụ generation ID hoặc task riêng cho từng tác vụ).

## Action dispatcher và effect

`HKActionDispatcher<Action>` chuyển action qua handler. `HKEffectHandler` chạy `Effect<Action>` và đưa action về main actor. `Effect.send(action)` phát một action; `.none` không làm gì. Giữ HKCancellableTask mà `handle(_:)` trả về bằng `store` nếu muốn ViewModel sở hữu và hủy effect.

## Binding và preview

| Helper | Dùng khi |
| --- | --- |
| `TwoWayBinding` | Tạo SwiftUI Binding bằng get/set closure |
| `Binding.map` | Chuyển một phần giá trị sang binding khác |
| `Binding.onChange` | Chạy callback sau setter |
| `Binding<Bool>.inverted` | Binding boolean đảo |
| `HKDebouncedBinding` | Giá trị nhập cập nhật ngay, callback sau thời gian yên lặng |
| `HKMockViewModel` | Xem [Preview](../../../Sources/HydraKitMVVM/Preview/) để capture action trong preview/test |

Giữ HKDebouncedBinding bằng StateObject/owner phù hợp; truyền `.binding` vào text field. Delay mặc định 300 ms, callback chạy main actor. Không tạo adapter mới trong mỗi lần body render.
