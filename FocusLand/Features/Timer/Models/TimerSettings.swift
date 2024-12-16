import SwiftData
import SwiftUI

@Model
class TimerSettings {
    var workDuration: Int
    var breakDuration: Int
    var selectedColor: String
    var shortWorkMode: Bool
    var shortWorkDuration: Int
    var canSkipBreaks: Bool
    var dailyGoalHours: Double
    var activeDays: [Int]
    
    init(workDuration: Int = 25, 
         breakDuration: Int = 5, 
         selectedColor: String = "#FF9500",
         shortWorkMode: Bool = false,
         shortWorkDuration: Int = 5,
         canSkipBreaks: Bool = true,
         dailyGoalHours: Double = 4.0,
         activeDays: [Int] = Array(1...5)) {
        self.workDuration = workDuration
        self.breakDuration = breakDuration
        self.selectedColor = selectedColor
        self.shortWorkMode = shortWorkMode
        self.shortWorkDuration = shortWorkDuration
        self.canSkipBreaks = canSkipBreaks
        self.dailyGoalHours = dailyGoalHours
        self.activeDays = activeDays
    }
} 