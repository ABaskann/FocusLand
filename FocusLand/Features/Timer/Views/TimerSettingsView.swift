import SwiftUI
import SwiftData

struct TimerSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var settings: TimerSettings
    let accentColor: Color
    
    var body: some View {
        NavigationView {
            Form {
                Section("Timer Durations") {
                    Stepper("Work Duration: \(settings.workDuration) min", 
                           value: $settings.workDuration,
                           in: 15...60,
                           step: 5)
                    
                    Stepper("Short Break: \(settings.shortBreakDuration) min",
                           value: $settings.shortBreakDuration,
                           in: 3...10,
                           step: 1)
                    
                    Stepper("Long Break: \(settings.longBreakDuration) min",
                           value: $settings.longBreakDuration,
                           in: 10...30,
                           step: 5)
                    
                    Stepper("Long Break After: \(settings.pomodorosBeforeLongBreak) pomodoros",
                           value: $settings.pomodorosBeforeLongBreak,
                           in: 2...6,
                           step: 1)
                }
                
                Section("Daily Goal") {
                    Stepper("Target: \(settings.dailyGoalPomodoros) pomodoros",
                           value: $settings.dailyGoalPomodoros,
                           in: 1...16,
                           step: 1)
                }
                
                Section("Recommendations") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("• Work: 25 minutes")
                        Text("• Short Break: 5 minutes")
                        Text("• Long Break: 15 minutes")
                        Text("• Long Break After: 4 pomodoros")
                        Text("• Daily Goal: 8-12 pomodoros")
                    }
                    .foregroundColor(.gray)
                    .font(.caption)
                    
                    Button("Reset to Default") {
                        resetToDefault()
                    }
                    .foregroundColor(accentColor)
                }
            }
            .navigationTitle("Timer Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(accentColor)
                }
            }
        }
    }
    
    private func resetToDefault() {
        settings.workDuration = 25
        settings.shortBreakDuration = 5
        settings.longBreakDuration = 15
        settings.pomodorosBeforeLongBreak = 4
        settings.dailyGoalPomodoros = 8
    }
} 