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
            timeRemaining = settings?.shortWorkMode == true ? 
                (settings?.shortWorkDuration ?? 5) * 60 : 
                (settings?.workDuration ?? 25) * 60
        } else {
            timeRemaining = (settings?.breakDuration ?? 5) * 60
        }
    }
} 