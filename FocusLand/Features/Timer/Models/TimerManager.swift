import SwiftUI
import SwiftData

@Observable
class TimerManager {
    var timeRemaining: Int
    var isActive: Bool = false
    var isWorkTime: Bool = true
    var consecutiveWorkPeriods: Int = 0
    
    init(initialTime: Int = 1500) {
        self.timeRemaining = initialTime
    }
    
    func resetTimer(settings: TimerSettings?) {
        if isWorkTime {
            timeRemaining = (settings?.workDuration ?? 25) * 60
        } else {
            if consecutiveWorkPeriods >= (settings?.pomodorosBeforeLongBreak ?? 4) {
                timeRemaining = (settings?.longBreakDuration ?? 15) * 60
                consecutiveWorkPeriods = 0
            } else {
                timeRemaining = (settings?.shortBreakDuration ?? 5) * 60
            }
        }
    }
    
    // New method for updating visual settings without affecting the timer
    func updateVisualSettings() {
        // No timer reset, just trigger UI update
    }
} 
