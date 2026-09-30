# Navigation

Target `IronBitCoreKitNavigation` cung cấp route abstraction, router và coordinator.

## Thành Phần

- `Route`, `AnyRoute`, `RouteIdentifier`.
- `NavigationRouter` để push/pop/present route.
- `BaseCoordinator` để quản lý flow và child coordinators.
- `DeepLinkHandler` để parse URL và điều hướng.
- `TabCoordinator`, `SheetCoordinator`, `FlowCoordinator` cho flow nâng cao.

## Ví Dụ

```swift
struct HomeRoute: Route {
    let routeIdentifier: RouteIdentifier = "home"
}

let router = NavigationRouter()
router.push(HomeRoute())
```
