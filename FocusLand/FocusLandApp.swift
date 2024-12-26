//
//  FocusLandApp.swift
//  FocusLand
//
//  Created by Armağan Başkan on 16.12.2024.
//

import SwiftUI
import SwiftData
import UserNotifications
import AVFoundation

@main
struct FocusLandApp: App {
    let container: ModelContainer
    @State private var timerManager = TimerManager()
    @State private var soundManager = SoundManager()
    
    init() {
        do {
            container = try ModelContainer(for: TimerSettings.self, FocusSession.self)
            
            // Request notification permissions when app launches
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if let error = error {
                    print("Error requesting notification permission: \(error)")
                }
            }
            
            // Configure audio session
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            fatalError("Failed to initialize Swift Data container")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(timerManager)
                .environment(soundManager)
        }
        .modelContainer(container)
    }
}
