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
    
    init(workDuration: Int = 25, 
         breakDuration: Int = 5, 
         selectedColor: String = "#FF9500",
         shortWorkMode: Bool = false,
         shortWorkDuration: Int = 5,
         canSkipBreaks: Bool = true) {
        self.workDuration = workDuration
        self.breakDuration = breakDuration
        self.selectedColor = selectedColor
        self.shortWorkMode = shortWorkMode
        self.shortWorkDuration = shortWorkDuration
        self.canSkipBreaks = canSkipBreaks
    }
} 