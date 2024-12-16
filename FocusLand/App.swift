import SwiftUI
import SwiftData

@main
struct FocusApp: App {
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
            MainTabView()
        }
        .modelContainer(container)
    }
}


