import SwiftData
import SwiftUI

@Model
class TimerSettings {
    var workDuration: Int
    var breakDuration: Int
    var longBreakDuration: Int
    var selectedColor: String
    var shortWorkMode: Bool
    var shortWorkDuration: Int
    var canSkipBreaks: Bool
    var dailyGoalHours: Double
    var activeDays: [Int]
    var autoStartNextSession: Bool
    var reminderTime: Date
    var reminderDays: Set<Int>
    var enableNotifications: Bool
    
    init(workDuration: Int = 25, 
         breakDuration: Int = 5,
         longBreakDuration: Int = 15,
         selectedColor: String = "#FF9500",
         shortWorkMode: Bool = false,
         shortWorkDuration: Int = 5,
         canSkipBreaks: Bool = true,
         dailyGoalHours: Double = 4.0,
         activeDays: [Int] = Array(1...5),
         autoStartNextSession: Bool = false,
         reminderTime: Date = Calendar.current.date(from: DateComponents(hour: 9, minute: 0)) ?? Date(),
         reminderDays: Set<Int> = Set(1...5),
         enableNotifications: Bool = true) {
        self.workDuration = workDuration
        self.breakDuration = breakDuration
        self.longBreakDuration = longBreakDuration
        self.selectedColor = selectedColor
        self.shortWorkMode = shortWorkMode
        self.shortWorkDuration = shortWorkDuration
        self.canSkipBreaks = canSkipBreaks
        self.dailyGoalHours = dailyGoalHours
        self.activeDays = activeDays
        self.autoStartNextSession = autoStartNextSession
        self.reminderTime = reminderTime
        self.reminderDays = reminderDays
        self.enableNotifications = enableNotifications
    }
} 