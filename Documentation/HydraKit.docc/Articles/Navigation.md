# Navigation

Target `HydraKitNavigation` cung cấp route abstraction, router và coordinator.

## Thành Phần

- `Route`, `AnyRoute`, `RouteIdentifier`.
- `HKNavigationRouter` để push/pop/present route.
- `HKBaseCoordinator` để quản lý flow và child coordinators.
- `HKDeepLinkHandler` để parse URL và điều hướng.
- `HKTabCoordinator`, `HKSheetCoordinator`, `HKFlowCoordinator` cho flow nâng cao.

## Ví Dụ

```swift
struct HomeRoute: Route {
    let routeIdentifier: RouteIdentifier = "home"
}

let router = HKNavigationRouter()
router.push(HomeRoute())
```
