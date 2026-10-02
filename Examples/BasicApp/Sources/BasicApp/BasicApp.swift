import HydraKitUI
import SwiftUI

@main
struct BasicApp: App {
    var body: some Scene {
        WindowGroup {
            BasicContentView()
                // Theme được inject ở root để tất cả component con dùng chung token.
                .ironBitTheme(DefaultTheme())
        }
    }
}

struct BasicContentView: View {
    @State private var notificationsEnabled = true

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            IBText("IronBit Basic App", variant: .title)

            IBCard(variant: .outlined) {
                VStack(alignment: .leading, spacing: 12) {
                    IBText("Component demo", variant: .headline)
                    IBChip("SwiftUI", variant: .soft, isSelected: true)
                    IBToggle("Bật thông báo", isOn: $notificationsEnabled)
                    IBButton("Tiếp tục") {
                        // Đây là nơi app thật gửi ViewAction hoặc điều hướng.
                        print("Continue tapped")
                    }
                }
            }

            IBProgressView("Đang đồng bộ", variant: .linear(0.65))
        }
        .padding(24)
        .frame(minWidth: 420, minHeight: 320)
    }
}
