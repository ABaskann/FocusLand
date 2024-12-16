import Foundation
import SwiftData

struct Goal: Identifiable {
    let id: UUID
    var title: String
    var targetHours: Double
    var completedMinutes: Int
    var date: Date
    
    var completedHours: Double {
        Double(completedMinutes) / 60.0
    }
    
    var progress: Double {
        completedHours / targetHours
    }
}

// Add FocusSession model to track completed sessions
@Model
class FocusSession {
    var duration: Int  // in minutes
    var date: Date
    var isCompleted: Bool
    
    init(duration: Int, date: Date = Date(), isCompleted: Bool = true) {
        self.duration = duration
        self.date = date
        self.isCompleted = isCompleted
    }
} 