import AVFoundation

@Observable
class SoundManager {
    private var audioPlayer: AVAudioPlayer?
    var isPlaying = false
    var volume: Float = 0.5
    var selectedSound: TimerSound = .healingWater
    
    enum TimerSound: String, CaseIterable {
        case healingWater = "HealingWater"
        case japaneseGarden = "JapaneseGarden"
        case nightscape = "Nightscape"
        case rainOnATent = "RainOnATent"
        case thunderRain = "ThunderRain"
        case whiteNoise = "WhiteNoise"
        case windRainStorm = "WindRainStorm"
        case winterWalk = "WinterWalk"
        case none = "none"
        
        var name: String {
            switch self {
            case .healingWater: return "Healing Water"
            case .japaneseGarden: return "Japanese Garden"
            case .nightscape: return "Nightscape"
            case .rainOnATent: return "Rain on a Tent"
            case .thunderRain: return "Thunder Rain"
            case .whiteNoise: return "White Noise"
            case .windRainStorm: return "Wind Rain Storm"
            case .winterWalk: return "Winter Walk"
            case .none: return "None"
            }
        }
        
        var icon: String {
            switch self {
            case .healingWater: return "drop.fill"
            case .japaneseGarden: return "leaf.fill"
            case .nightscape: return "moon.stars.fill"
            case .rainOnATent: return "tent.fill"
            case .thunderRain: return "cloud.bolt.rain.fill"
            case .whiteNoise: return "waveform"
            case .windRainStorm: return "wind"
            case .winterWalk: return "snowflake"
            case .none: return "speaker.slash"
            }
        }
    }
    
    func playSound() {
        guard selectedSound != .none else { return }
        
        if audioPlayer == nil {
            if let soundURL = Bundle.main.url(forResource: selectedSound.rawValue, withExtension: "mp3") {
                do {
                    try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
                    try AVAudioSession.sharedInstance().setActive(true)
                    
                    audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                    audioPlayer?.numberOfLoops = -1 // Loop indefinitely
                    audioPlayer?.volume = volume
                } catch {
                    print("Failed to initialize audio player: \(error)")
                    return
                }
            }
        }
        
        audioPlayer?.play()
        isPlaying = true
    }
    
    func stopSound() {
        audioPlayer?.stop()
        isPlaying = false
    }
    
    func updateVolume() {
        audioPlayer?.volume = volume
    }
    
    func changeSound() {
        stopSound()
        audioPlayer = nil
        if isPlaying {
            playSound()
        }
    }
} 
