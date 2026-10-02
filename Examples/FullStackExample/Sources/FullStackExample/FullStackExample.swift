import Foundation
import HydraKitMVVM
import HydraKitNavigation
import HydraKitRepository
import HydraKitUI
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
final class HomeViewModel: HKBaseViewModel<HomeAction> {
    let state = HKStateContainer<[Todo]>()
    private let repository: HKMockRepository<UUID, Todo>
    private let router: HKNavigationRouter

    init(repository: HKMockRepository<UUID, Todo>, router: HKNavigationRouter) {
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
        store(HKCancellableTask(task))
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
            let repository = HKMockRepository(values: todos, idProvider: \.id)
            let router = HKNavigationRouter()
            let viewModel = HomeViewModel(repository: repository, router: router)

            FullStackContentView(viewModel: viewModel, router: router)
                .ironBitTheme(DefaultTheme())
        }
    }
}

struct FullStackContentView: View {
    @StateObject var viewModel: HomeViewModel
    @StateObject var router: HKNavigationRouter
    @ObservedObject private var state: HKStateContainer<[Todo]>

    init(viewModel: HomeViewModel, router: HKNavigationRouter) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _router = StateObject(wrappedValue: router)
        self.state = viewModel.state
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HKText("Full Stack Example", variant: .title)

            ContentStateView(state: contentState(from: state.state), retry: { viewModel.send(.reload) }) { todos in
                VStack(spacing: 8) {
                    ForEach(todos) { todo in
                        HKButton(todo.title, variant: .secondary) {
                            viewModel.send(.select(todo))
                        }
                    }
                }
            }
            .frame(minHeight: 160)

            HKCard {
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

    private func contentState(from state: HKViewState<[Todo]>) -> HKContentState<[Todo]> {
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
