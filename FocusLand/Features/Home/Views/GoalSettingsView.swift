import SwiftUI
import SwiftData

struct GoalSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Bindable var settings: TimerSettings
    let accentColor: Color
    
    @State private var selectedGoalHours: Double
    @State private var selectedDays = Set<Int>()
    @State private var showAlert = false
    
    private let weekDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    init(settings: TimerSettings, accentColor: Color) {
        self.settings = settings
        self.accentColor = accentColor
        _selectedGoalHours = State(initialValue: settings.dailyGoalHours)
        // Initialize selected days from current settings
        _selectedDays = State(initialValue: Set(settings.activeDays))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Daily Goal") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Target Hours: \(selectedGoalHours, specifier: "%.1f")")
                            .foregroundColor(accentColor)
                        
                        Slider(value: $selectedGoalHours, in: 1...12, step: 0.5)
                            .tint(accentColor)
                    }
                    .padding(.vertical, 8)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recommended:")
                            .foregroundColor(.gray)
                        
                        HStack(spacing: 12) {
                            ForEach([4, 6, 8], id: \.self) { hours in
                                Button(action: { selectedGoalHours = Double(hours) }) {
                                    Text("\(hours) hours")
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(accentColor, lineWidth: 1)
                                        )
                                        .background(
                                            selectedGoalHours == Double(hours) ?
                                                accentColor.opacity(0.2) :
                                                Color.clear
                                        )
                                        .cornerRadius(8)
                                }
                                .buttonStyle(.plain)
                                .foregroundColor(accentColor)
                            }
                        }
                    }
                }
                
                Section("Active Days") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(0..<7) { index in
                                DayToggle(
                                    day: weekDays[index],
                                    isSelected: selectedDays.contains(index),
                                    accentColor: accentColor
                                ) {
                                    toggleDay(index)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    
                    HStack(spacing: 12) {
                        QuickSelectButton(
                            title: "Weekdays",
                            accentColor: accentColor,
                            isSelected: selectedDays == Set(1...5)
                        ) {
                            selectedDays = Set(1...5)
                        }
                        
                        QuickSelectButton(
                            title: "All Days",
                            accentColor: accentColor,
                            isSelected: selectedDays == Set(0...6)
                        ) {
                            selectedDays = Set(0...6)
                        }
                        
                        QuickSelectButton(
                            title: "Clear",
                            accentColor: accentColor,
                            isSelected: selectedDays.isEmpty
                        ) {
                            selectedDays.removeAll()
                        }
                    }
                    .padding(.top, 8)
                }
                
                Section {
                    Button("Reset All Progress", role: .destructive) {
                        showAlert = true
                    }
                }
            }
            .navigationTitle("Goal Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveSettings()
                    }
                    .foregroundColor(accentColor)
                    .disabled(selectedDays.isEmpty)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(accentColor)
                }
            }
            .alert("Reset Progress", isPresented: $showAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    resetProgress()
                }
            } message: {
                Text("This will reset all your focus session progress. This action cannot be undone.")
            }
        }
    }
    
    private func toggleDay(_ day: Int) {
        if selectedDays.contains(day) {
            selectedDays.remove(day)
        } else {
            selectedDays.insert(day)
        }
    }
    
    private func saveSettings() {
        settings.dailyGoalHours = selectedGoalHours
        settings.activeDays = Array(selectedDays).sorted()
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Error saving settings: \(error)")
        }
    }
    
    private func resetProgress() {
        // Now we can implement the reset functionality
        let fetchDescriptor = FetchDescriptor<FocusSession>()
        if let sessions = try? modelContext.fetch(fetchDescriptor) {
            sessions.forEach { modelContext.delete($0) }
        }
    }
}

struct DayToggle: View {
    let day: String
    let isSelected: Bool
    let accentColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(day)
                .font(.caption)
                .fontWeight(.medium)
                .frame(width: 40)
                .padding(.vertical, 8)
                .background(isSelected ? accentColor : Color.clear)
                .foregroundColor(isSelected ? .black : accentColor)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(accentColor, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

struct QuickSelectButton: View {
    let title: String
    let accentColor: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(accentColor, lineWidth: 1)
                )
                .background(
                    isSelected ?
                        accentColor.opacity(0.2) :
                        Color.clear
                )
                .cornerRadius(8)
                .foregroundColor(accentColor)
        }
        .buttonStyle(.plain)
    }
} 