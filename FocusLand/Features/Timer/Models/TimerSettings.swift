import SwiftData
import SwiftUI

@Model
class TimerSettings {
    var workDuration: Int
    var shortBreakDuration: Int
    var longBreakDuration: Int
    var pomodorosBeforeLongBreak: Int
    var selectedColor: String
    var dailyGoalPomodoros: Int
    var activeDays: [Int]
    var isNotificationsEnabled: Bool
    var isTimerCompletionEnabled: Bool
    var isDailyReminderEnabled: Bool
    var isDailyGoalEnabled: Bool
    var isStreakEnabled: Bool
    var dailyReminderTime: Date
    var timerStyle: String
    
    var timerStyleEnum: TimerStyle {
        TimerStyle(rawValue: timerStyle) ?? .circular
    }
    
    init(workDuration: Int = 25, 
         shortBreakDuration: Int = 5,
         longBreakDuration: Int = 15,
         pomodorosBeforeLongBreak: Int = 4,
         selectedColor: String = "#FF9500",
         dailyGoalPomodoros: Int = 8,
         activeDays: [Int] = Array(1...5)) {
        self.workDuration = workDuration
        self.shortBreakDuration = shortBreakDuration
        self.longBreakDuration = longBreakDuration
        self.pomodorosBeforeLongBreak = pomodorosBeforeLongBreak
        self.selectedColor = selectedColor
        self.dailyGoalPomodoros = dailyGoalPomodoros
        self.activeDays = activeDays
        self.isNotificationsEnabled = false
        self.isTimerCompletionEnabled = true
        self.isDailyReminderEnabled = false
        self.isDailyGoalEnabled = true
        self.isStreakEnabled = true
        self.dailyReminderTime = Calendar.current.date(from: DateComponents(hour: 9, minute: 0)) ?? Date()
        self.timerStyle = TimerStyle.circular.rawValue
    }
} 