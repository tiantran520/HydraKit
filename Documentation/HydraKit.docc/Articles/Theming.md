# Theming

Target `HydraKitUI` dùng design tokens và `ThemeEnvironment` để theme hóa component.

## Token

- `ColorTokens`
- `TypographyTokens`
- `SpacingTokens`
- `RadiusTokens`
- `ShadowTokens`
- `AnimationTokens`

## Ví Dụ

```swift
VStack {
    IBText("Hydra", variant: .title)
    IBButton("Bắt đầu") {}
}
.ironBitTheme(DefaultTheme())
```

Component trong `Components/` đọc theme qua environment nên có thể đổi theme ở cấp app hoặc màn hình.
