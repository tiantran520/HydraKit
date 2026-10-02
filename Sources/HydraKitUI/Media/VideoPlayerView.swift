import SwiftUI

#if canImport(AVKit) && !os(watchOS)
import AVKit

/// A small wrapper around SwiftUI VideoPlayer.
public struct VideoPlayerView: View {
    private let player: AVPlayer

    /// Creates a video player from a URL.
    public init(url: URL) {
        self.player = AVPlayer(url: url)
    }

    /// Creates a video player from an AVPlayer.
    public init(player: AVPlayer) {
        self.player = player
    }

    /// The video player body.
    public var body: some View {
        VideoPlayer(player: player)
    }
}
#else
/// A fallback video placeholder for platforms without AVKit video playback.
public struct VideoPlayerView: View {
    /// Creates a fallback video player.
    public init(url: URL) {}

    /// The fallback body.
    public var body: some View {
        Text("Video không được hỗ trợ trên nền tảng này.")
    }
}
#endif
