import SwiftUI
import AVFoundation
import AVKit

@MainActor
final class MediaViewModel: ObservableObject {
    @Published var isPlayingAudio = false
    @Published var isPlayingVideo = false
    @Published var selectedImageData: Data?

    private var audioPlayer: AVAudioPlayer?

    /// Video de muestra incluido dentro de la app (funciona sin internet).
    let videoPlayer: AVPlayer = {
        if let url = Bundle.main.url(forResource: "muestra", withExtension: "mp4") {
            return AVPlayer(url: url)
        }
        return AVPlayer()
    }()

    func toggleAudio() {
        if isPlayingAudio {
            audioPlayer?.pause()
            isPlayingAudio = false
            return
        }
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setActive(true)
        if audioPlayer == nil, let url = Bundle.main.url(forResource: "tono", withExtension: "wav") {
            audioPlayer = try? AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.prepareToPlay()
        }
        isPlayingAudio = audioPlayer?.play() ?? false
    }

    func toggleVideo() {
        if isPlayingVideo {
            videoPlayer.pause()
        } else {
            videoPlayer.play()
        }
        isPlayingVideo.toggle()
    }
}
