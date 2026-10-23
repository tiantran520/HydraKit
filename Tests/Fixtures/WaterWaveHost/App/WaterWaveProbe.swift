import SwiftUI
import HydraKitUI

@main struct WaterWaveProbe: App {
    var body: some Scene { WindowGroup { Probe() } }
}

private struct Probe: View {
    @State private var percentage = 50.0
    @State private var yellow = true
    @State private var animate = true

    var body: some View {
        VStack(spacing: 20) {
            HKWaterWave(percentage: percentage, color: yellow ? .yellow : .blue,
                        textColor: yellow ? .black : .white, isAnimating: animate,
                        accessibilityLabel: Text("Daily water"))
                .frame(width: 220, height: 220)
                .accessibilityIdentifier("water-gauge")
            HStack {
                Button("Empty") { percentage = 0 }
                Button("Half") { percentage = 50 }
                Button("Three quarters") { percentage = 75 }
                Button("Full") { percentage = 100 }
            }
            Button("Above range") { percentage = 150 }
            Button("Below range") { percentage = -10 }
            Button("Change color") { yellow.toggle() }
            Button("Pause waves") { animate = false }
        }
        .buttonStyle(.bordered)
        .padding()
    }
}
