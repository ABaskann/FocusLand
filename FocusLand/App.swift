import SwiftUI
import SwiftData

@main
struct FocusApp: App {
    let container: ModelContainer
    @State private var timerManager = TimerManager()
    
    init() {
        do {
            container = try ModelContainer(for: TimerSettings.self)
        } catch {
            fatalError("Failed to initialize Swift Data container")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(timerManager)
        }
        .modelContainer(container)
    }
}


