import Foundation
import IronBitCoreKitMVVM
import IronBitCoreKitNavigation
import IronBitCoreKitRepository
import IronBitCoreKitUI
import SwiftUI

struct Todo: Codable, Identifiable, Sendable, Hashable {
    let id: UUID
    let title: String
}

enum HomeAction: ViewAction {
    case onAppear
    case reload
    case select(Todo)
}

struct TodoRoute: Route {
    let routeIdentifier: RouteIdentifier = "todo"
    let todo: Todo
}

@MainActor
final class HomeViewModel: BaseViewModel<HomeAction> {
    let state = StateContainer<[Todo]>()
    private let repository: MockRepository<UUID, Todo>
    private let router: NavigationRouter

    init(repository: MockRepository<UUID, Todo>, router: NavigationRouter) {
        self.repository = repository
        self.router = router
        super.init()
    }

    override func send(_ action: HomeAction) {
        switch action {
        case .onAppear, .reload:
            load()
        case let .select(todo):
            // Coordinator/router được inject để ViewModel không phụ thuộc trực tiếp vào View.
            router.push(TodoRoute(todo: todo))
        }
    }

    private func load() {
        state.setState(.loading)
        let task = Task { @MainActor in
            do {
                let todos = try await repository.readAll()
                state.setLoaded(todos)
            } catch {
                state.setError(error)
            }
        }
        store(CancellableTask(task))
    }
}

@main
struct FullStackExample: App {
    var body: some Scene {
        WindowGroup {
            let todos = [
                Todo(id: UUID(), title: "Tạo UI"),
                Todo(id: UUID(), title: "Gọi Repository"),
                Todo(id: UUID(), title: "Điều hướng")
            ]
            let repository = MockRepository(values: todos, idProvider: \.id)
            let router = NavigationRouter()
            let viewModel = HomeViewModel(repository: repository, router: router)

            FullStackContentView(viewModel: viewModel, router: router)
                .ironBitTheme(DefaultTheme())
        }
    }
}

struct FullStackContentView: View {
    @StateObject var viewModel: HomeViewModel
    @StateObject var router: NavigationRouter
    @ObservedObject private var state: StateContainer<[Todo]>

    init(viewModel: HomeViewModel, router: NavigationRouter) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _router = StateObject(wrappedValue: router)
        self.state = viewModel.state
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            IBText("Full Stack Example", variant: .title)

            ContentStateView(state: contentState(from: state.state), retry: { viewModel.send(.reload) }) { todos in
                VStack(spacing: 8) {
                    ForEach(todos) { todo in
                        IBButton(todo.title, variant: .secondary) {
                            viewModel.send(.select(todo))
                        }
                    }
                }
            }
            .frame(minHeight: 160)

            IBCard {
                Text("Route stack: " + router.path.map(\.routeIdentifier.rawValue).joined(separator: " > "))
                    .font(.caption)
            }
        }
        .padding(24)
        .frame(minWidth: 480, minHeight: 360)
        .onFirstAppear {
            viewModel.send(.onAppear)
        }
    }

    private func contentState(from state: ViewState<[Todo]>) -> ContentState<[Todo]> {
        switch state {
        case .idle, .loading:
            return .loading
        case let .loaded(todos):
            return todos.isEmpty ? .empty : .content(todos)
        case let .error(error):
            return .error(error.localizedDescription)
        }
    }
}
