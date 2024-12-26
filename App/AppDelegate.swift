import UIKit
import BackgroundTasks

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Register background tasks
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: "com.app.FocusLand.timer.refresh",
            using: nil) { task in
                self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
        
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: "com.app.FocusLand.timer.processing",
            using: nil) { task in
                self.handleBackgroundProcessing(task: task as! BGProcessingTask)
        }
        
        return true
    }
    
    private func handleAppRefresh(task: BGAppRefreshTask) {
        // Handle background refresh
        task.expirationHandler = {
            // Clean up any tasks if needed
        }
        
        // Your background refresh code here
        
        task.setTaskCompleted(success: true)
    }
    
    private func handleBackgroundProcessing(task: BGProcessingTask) {
        // Handle background processing
        task.expirationHandler = {
            // Clean up any tasks if needed
        }
        
        // Your background processing code here
        
        task.setTaskCompleted(success: true)
    }
} 