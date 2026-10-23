# Flashcard deck UI tests

Offline app hosting the local `HKFlashcardDeck` package component. Sample cards
have place names on the front and English descriptions on the reverse.

From the repository root, with Xcode and XcodeGen installed:

```sh
xcodegen generate --spec Tests/Fixtures/FlashcardDeckHost/project.yml
xcodebuild test \
  -project Tests/Fixtures/FlashcardDeckHost/FlashcardDeckProbe.xcodeproj \
  -scheme FlashcardDeckProbe \
  -destination 'platform=iOS Simulator,name=iPhone 17,OS=26.0' \
  -collect-test-diagnostics never \
  -parallel-testing-enabled NO CODE_SIGNING_ALLOWED=NO
```

Choose an installed simulator/OS. Generated projects are ignored by git. XcodeGen
is only a tool for this optional host; no dependencies are added to the library.

The suite checks tap/controlled flip, physical left/right swipes, RTL, callback
counts, front reset, completion/replay, disabled state, short and vertical drags,
parent-owned source removal, empty data, overlay touch isolation and scrolling over
a card in a parent ScrollView. Parent scrolling is checked using actual screen
frames, with a native Button calibration; the test avoids relying on a geometry
preference that can report a stationary coordinate space. Screenshot attachments capture both faces and the completed state.
SwiftPM tests independently cover gesture classification and study-state rules.

These UI tests do not verify VoiceOver speech or the device Reduce Motion setting.
Those preferences should also be exercised in the integrating app on supported
OS versions. iOS 17 receives an availability build check separately.
