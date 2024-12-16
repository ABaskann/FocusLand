import SwiftUI
import SwiftData

struct TimerSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var settings: TimerSettings
    let accentColor: Color
    
    var body: some View {
        NavigationView {
            Form {
                Section("Work Duration") {
                    Toggle("Short Work Mode", isOn: $settings.shortWorkMode)
                        .tint(accentColor)
                    
                    if settings.shortWorkMode {
                        Stepper("Short Work: \(settings.shortWorkDuration) min", 
                               value: $settings.shortWorkDuration, in: 1...15)
                            .foregroundColor(accentColor)
                    } else {
                        Stepper("Work: \(settings.workDuration) min", 
                               value: $settings.workDuration, in: 15...60)
                            .foregroundColor(accentColor)
                    }
                }
                .foregroundColor(accentColor)
                
                Section("Break Settings") {
                    Stepper("Break: \(settings.breakDuration) min", 
                           value: $settings.breakDuration, in: 1...15)
                        .foregroundColor(accentColor)
                    Toggle("Allow Skip Breaks", isOn: $settings.canSkipBreaks)
                        .tint(accentColor)
                }
                .foregroundColor(accentColor)
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
            .tint(accentColor)
        }
    }
} 