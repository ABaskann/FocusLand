//
//  FocusLandApp.swift
//  FocusLand
//
//  Created by Armağan Başkan on 16.12.2024.
//

import SwiftUI
import SwiftData

struct FocusLandApp: App {
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: TimerSettings.self)
        } catch {
            fatalError("Failed to initialize Swift Data container")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            PomodoroTimerView()
        }
        .modelContainer(container)
    }
}
