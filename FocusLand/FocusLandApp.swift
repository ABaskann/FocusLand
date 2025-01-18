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
import RevenueCat
import RevenueCatUI
import GoogleMobileAds

@main
struct FocusLandApp: App {
    let container: ModelContainer
    @State private var timerManager = TimerManager()
    @State private var soundManager = SoundManager()
    @StateObject private var userViewModel = UserViewModel.shared
    
    init() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
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
            
            // Configure RevenueCat
            Purchases.logLevel = .debug
            Purchases.configure(withAPIKey: Secrets.apikey)
            Purchases.shared.delegate = PurchasesDelegateHandler.shared
        } catch {
            fatalError("Failed to initialize Swift Data container")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(timerManager)
                .environment(soundManager)
                .task {
                    // Fetch offerings when app launches
                    do {
                        userViewModel.offerings = try await Purchases.shared.offerings()
                        userViewModel.customerInfo = try await Purchases.shared.customerInfo()
                    } catch {
                        print("Error fetching offerings: \(error)")
                    }
                }
        }
        .modelContainer(container)
    }
}
