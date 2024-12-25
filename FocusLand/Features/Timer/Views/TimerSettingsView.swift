import SwiftUI
import SwiftData

struct TimerSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(TimerManager.self) private var timerManager
    @Bindable var settings: TimerSettings
    let accentColor: Color
    
    private let workDurationRange = 15...60
    private let shortBreakRange = 3...10
    private let longBreakRange = 10...30
    private let pomodorosRange = 2...6
    private let dailyGoalRange = 1...16
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Timer Settings Group
                    VStack(spacing: 12) {
                        Text("Timer Settings")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Work Duration
                        CompactSettingRow(
                            title: "Work",
                            icon: "brain.head.profile",
                            value: Double(settings.workDuration),
                            range: Double(workDurationRange.lowerBound)...Double(workDurationRange.upperBound),
                            step: 5,
                            unit: "min",
                            accentColor: accentColor
                        ) { newValue in
                            settings.workDuration = Int(newValue)
                        }
                        
                        // Short Break
                        CompactSettingRow(
                            title: "Short Break",
                            icon: "cup.and.saucer",
                            value: Double(settings.shortBreakDuration),
                            range: Double(shortBreakRange.lowerBound)...Double(shortBreakRange.upperBound),
                            step: 1,
                            unit: "min",
                            accentColor: accentColor
                        ) { newValue in
                            settings.shortBreakDuration = Int(newValue)
                        }
                        
                        // Long Break
                        CompactSettingRow(
                            title: "Long Break",
                            icon: "figure.walk",
                            value: Double(settings.longBreakDuration),
                            range: Double(longBreakRange.lowerBound)...Double(longBreakRange.upperBound),
                            step: 5,
                            unit: "min",
                            accentColor: accentColor
                        ) { newValue in
                            settings.longBreakDuration = Int(newValue)
                        }
                        
                        Divider()
                            .background(Color.gray.opacity(0.3))
                        
                        // Long Break Interval
                        CompactSettingRow(
                            title: "Long Break After",
                            icon: "repeat",
                            value: Double(settings.pomodorosBeforeLongBreak),
                            range: Double(pomodorosRange.lowerBound)...Double(pomodorosRange.upperBound),
                            step: 1,
                            unit: "pomodoros",
                            accentColor: accentColor
                        ) { newValue in
                            settings.pomodorosBeforeLongBreak = Int(newValue)
                        }
                        
                        // Daily Goal
                        CompactSettingRow(
                            title: "Daily Goal",
                            icon: "target",
                            value: Double(settings.dailyGoalPomodoros),
                            range: Double(dailyGoalRange.lowerBound)...Double(dailyGoalRange.upperBound),
                            step: 1,
                            unit: "pomodoros",
                            accentColor: accentColor
                        ) { newValue in
                            settings.dailyGoalPomodoros = Int(newValue)
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(16)
                    
                    // Recommendations Section
                    VStack(spacing: 12) {
                        Text("Recommendations")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 8) {
                            GridRow {
                                RecommendationRow(icon: "brain", text: "Work: 25 min")
                                RecommendationRow(icon: "cup.and.saucer", text: "Short Break: 5 min")
                            }
                            GridRow {
                                RecommendationRow(icon: "figure.walk", text: "Long Break: 15 min")
                                RecommendationRow(icon: "repeat", text: "Long Break: 4 pomodoros")
                            }
                            GridRow {
                                RecommendationRow(icon: "target", text: "Daily Goal: 8-12 pomodoros")
                            }
                        }
                        
                        Button(action: resetToDefault) {
                            Text("Reset to Default")
                                .font(.subheadline)
                                .foregroundColor(accentColor)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(accentColor, lineWidth: 1)
                                )
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(16)
                }
                .padding()
            }
            .background(Color.black)
            .navigationTitle("Timer Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        timerManager.resetTimer(settings: settings)
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
        
        timerManager.resetTimer(settings: settings)
    }
}

struct CompactSettingRow: View {
    let title: String
    let icon: String
    let value: Double
    let range: ClosedRange<Double>
    let step: Double
    let unit: String
    let accentColor: Color
    let onValueChanged: (Double) -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Label(title, systemImage: icon)
                    .font(.subheadline)
                Spacer()
                Text("\(Int(value)) \(unit)")
                    .font(.subheadline)
                    .foregroundColor(accentColor)
            }
            
            Slider(
                value: Binding(
                    get: { value },
                    set: { onValueChanged($0) }
                ),
                in: range,
                step: step
            )
            .tint(accentColor)
        }
    }
}

struct RecommendationRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}
