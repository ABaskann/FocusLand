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
    }
} 