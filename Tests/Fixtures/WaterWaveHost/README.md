# Water wave UI host

Offline host for the local `HKWaterWave` component. It checks parent-driven
percentage updates, 0...100 clamping, native progress accessibility value,
color changes and paused motion. Screenshots capture the yellow reference gauge
and the blue paused gauge. SwiftPM includes separate path/phase and bitmap tests.

From the repository root, with Xcode and XcodeGen installed:

```sh
xcodegen generate --spec Tests/Fixtures/WaterWaveHost/project.yml
xcodebuild test \
  -project Tests/Fixtures/WaterWaveHost/WaterWaveProbe.xcodeproj \
  -scheme WaterWaveProbe \
  -destination 'platform=iOS Simulator,name=iPhone 17,OS=26.0' \
  -collect-test-diagnostics never \
  -parallel-testing-enabled NO CODE_SIGNING_ALLOWED=NO
```

Choose an installed simulator/OS. Generated projects are ignored by git.
The library gains no dependency; XcodeGen is only an optional test-host tool.
The host does not simulate VoiceOver speech or the OS Reduce Motion preference.
