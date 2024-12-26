//
//  SoundControlView.swift
//  FocusLand
//
//  Created by Armağan Başkan on 26.12.2024.
//


import SwiftUI

struct SoundControlView: View {
    @Environment(SoundManager.self) private var soundManager
    let accentColor: Color
    
    var body: some View {
        VStack(spacing: 20) {
            // Sound name with icon
            if soundManager.selectedSound != .none {
                Label(soundManager.selectedSound.name, systemImage: soundManager.selectedSound.icon)
                    .foregroundColor(accentColor)
            }
            
            // Volume slider
            if soundManager.selectedSound != .none {
                HStack(spacing: 12) {
                    Image(systemName: "speaker.fill")
                        .foregroundColor(accentColor)
                    
                    Slider(
                        value: .init(
                            get: { soundManager.volume },
                            set: { 
                                soundManager.volume = $0
                                soundManager.updateVolume()
                            }
                        ),
                        in: 0...1
                    )
                    .tint(accentColor)
                    
                    Image(systemName: "speaker.wave.3.fill")
                        .foregroundColor(accentColor)
                }
            }
            
            // Play/Stop button
            Button {
                if soundManager.isPlaying {
                    soundManager.stopSound()
                } else {
                    soundManager.playSound()
                }
            } label: {
                Image(systemName: soundManager.isPlaying ? "stop.fill" : "play.fill")
                    .font(.system(size: 24))
                    .foregroundColor(accentColor)
                    .frame(width: 44, height: 44)
            }
            
            // Sound selector
            Menu {
                ForEach(SoundManager.TimerSound.allCases, id: \.self) { sound in
                    Button {
                        soundManager.selectedSound = sound
                        soundManager.changeSound()
                    } label: {
                        Label(sound.name, systemImage: sound.icon)
                    }
                }
            } label: {
                Image(systemName: "ellipsis.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(accentColor)
            }
        }
        .padding(.vertical, 20)
    }
}