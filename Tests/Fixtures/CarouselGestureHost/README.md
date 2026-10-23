# Carousel gesture tests

This offline iOS app hosts `HKParallaxCarousel` from the local package. Its XCUITests
exercise fast swipes in LTR/RTL with normal and narrow cards, resizing while a
non-first card is selected, programmatic jumps, and the last-card boundary.
The package's SwiftPM tests cannot synthesize iOS touch gestures.

With Xcode and XcodeGen installed, generate the test host from the repository root:

```sh
xcodegen generate --spec Tests/Fixtures/CarouselGestureHost/project.yml
xcodebuild test \
  -project Tests/Fixtures/CarouselGestureHost/CarouselGestureProbe.xcodeproj \
  -scheme CarouselGestureProbe \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  -collect-test-diagnostics never \
  -parallel-testing-enabled NO CODE_SIGNING_ALLOWED=NO
```

Choose an installed simulator in `-destination`. The generated project is ignored
by git. XcodeGen is only a tool for this optional test host; the library has no
additional dependencies. Screenshot attachments are retained in the test results.
