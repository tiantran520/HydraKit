import SwiftUI

/// Offline controls for trying the public component directly in Canvas.
struct HKWaterWavePreview: View {
    @State private var percentage = 50.0
    @State private var yellow = true
    @State private var animating = true

    var body: some View {
        VStack(spacing: 20) {
            HKWaterWave(percentage: percentage, color: yellow ? .yellow : .blue,
                        textColor: yellow ? .black : .white, isAnimating: animating)
                .frame(maxWidth: 240)
            Slider(value: $percentage, in: 0...100, step: 1) { Text("Water percentage") }
            HStack {
                Button("Empty") { percentage = 0 }
                Button("50%") { percentage = 50 }
                Button("Full") { percentage = 100 }
            }
            .buttonStyle(.bordered)
            Toggle("Yellow water", isOn: $yellow)
            Toggle("Animate waves", isOn: $animating)
        }
    }
}
