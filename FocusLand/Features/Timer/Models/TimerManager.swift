import SwiftUI
import SwiftData

@Observable
class TimerManager {
    var timeRemaining: Int
    var isActive: Bool = false
    var isWorkTime: Bool = true
    var consecutiveWorkPeriods: Int = 0
    var isLongBreak: Bool = false
    
    private let haptics = UINotificationFeedbackGenerator()
    private let selectionHaptics = UISelectionFeedbackGenerator()
    
    init(initialTime: Int = 1500) {
        self.timeRemaining = initialTime
        haptics.prepare()
        selectionHaptics.prepare()
    }
    
    func toggleTimer(settings: TimerSettings?) {
        isActive.toggle()
        selectionHaptics.selectionChanged()
    }
    
    func resetTimer(settings: TimerSettings?) {
        if isWorkTime {
            timeRemaining = settings?.shortWorkMode == true ? 
                (settings?.shortWorkDuration ?? 5) * 60 : 
                (settings?.workDuration ?? 25) * 60
        } else {
            if consecutiveWorkPeriods >= 4 {
                timeRemaining = 15 * 60
                isLongBreak = true
            } else {
                timeRemaining = (settings?.breakDuration ?? 5) * 60
                isLongBreak = false
            }
        }
        
        // Haptic feedback for session change
        haptics.notificationOccurred(.success)
    }
    
    func sessionCompleted(settings: TimerSettings?) {
        haptics.notificationOccurred(.success)
        
        if isWorkTime {
            consecutiveWorkPeriods += 1
        }
        
        if isLongBreak && !isWorkTime {
            consecutiveWorkPeriods = 0
        }
        
        isWorkTime.toggle()
        
        if settings?.autoStartNextSession == true {
            resetTimer(settings: settings)
            isActive = true
        } else {
            isActive = false
            resetTimer(settings: settings)
        }
    }
} 