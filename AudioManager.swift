import SwiftUI
import AVFoundation

class AudioManager: ObservableObject {
    static let shared = AudioManager()
    
    var audioPlayer: AVAudioPlayer?
    @Published var isMuted: Bool = false {
        didSet {
            audioPlayer?.volume = isMuted ? 0 : 1
        }
    }
    
    private init() {
        setupBackgroundMusic()
    }
    
    func setupBackgroundMusic() {
        if let path = Bundle.main.path(forResource: "Storytelling-Essentials-Free-No-Copyright-Music-by-Liborio-Conti-01-Cinematic-Piano", ofType: ".mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.numberOfLoops = -1
                audioPlayer?.prepareToPlay()
            } catch {
                print("Error setting up background music")
            }
        }
    }
    
    func playBackgroundMusic() {
        if !isMuted {
            audioPlayer?.play()
        }
    }
    
    func toggleMute() {
        isMuted.toggle()
    }
}
