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
            // If we've completed enough work periods, use long break duration
            if consecutiveWorkPeriods >= (settings?.pomodorosBeforeLongBreak ?? 4) {
                timeRemaining = (settings?.longBreakDuration ?? 15) * 60
                consecutiveWorkPeriods = 0  // Reset the counter after a long break
            } else {
                timeRemaining = (settings?.shortBreakDuration ?? 5) * 60
            }
        }
    }
} 