# Bank card stack gesture host

Offline app for the new `HKBankCardStack` component. It uses the local HydraKitUI
package and makes no network or bank service requests. Test cards contain demo data.

Generate the optional host with XcodeGen from the repository root:

```sh
xcodegen generate --spec Tests/Fixtures/BankCardStackHost/project.yml
xcodebuild test \
  -project Tests/Fixtures/BankCardStackHost/BankCardStackProbe.xcodeproj \
  -scheme BankCardStackProbe \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  -collect-test-diagnostics never \
  -parallel-testing-enabled NO CODE_SIGNING_ALLOWED=NO
```

Choose an installed simulator. Generated Xcode projects are ignored by git.
XcodeGen is only a test-host tool; the library gains no dependency.

The UI suite exercises physical left/right/down/up gestures, RTL content,
parent and local selection, returning from focus, disabled interactions,
delete-request callbacks, the native menu alternative, and rear-card target size.
Screenshot attachments cover the collapsed, fan, expanded and revealed states.
SwiftPM unit tests independently verify state rules, transformed bounds and
selection repair when data is removed or reordered.

The verified iOS 26 Simulator run passed all seven UI tests. Opening the native
SwiftUI context menu also emitted UIKit runtime warnings naming
`_UIGravityWellEffectAnchorView` and `_UIReparentingView`; the component itself
does not add UIKit subviews. Verify the native menu and VoiceOver on the devices
and OS versions used by your app. iOS 17 was build-checked, not gesture-tested.
