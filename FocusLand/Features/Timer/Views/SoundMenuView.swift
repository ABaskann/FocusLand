import SwiftUI

struct SoundMenuView: View {
    @Environment(SoundManager.self) private var soundManager
    @ObservedObject var userModel = UserViewModel.shared
    @Binding var showPaywall: Bool
    let timerColor: Color
    
    var body: some View {
        Menu {
            ForEach(SoundManager.TimerSound.allCases, id: \.self) { sound in
                if sound == .none || userModel.subscriptionActive || sound == .nightscape {
                    Button {
                        soundManager.selectedSound = sound
                        soundManager.changeSound()
                    } label: {
                        Label(sound.name, systemImage: sound.icon)
                    }
                } else {
                    Button {
                        showPaywall = true
                    } label: {
                        Label(sound.name, systemImage: "lock.fill")
                    }
                }
            }
        } label: {
            Image(systemName: "music.note.list")
                .font(.system(size: 22))
                .foregroundColor(timerColor)
        }
    }
} 