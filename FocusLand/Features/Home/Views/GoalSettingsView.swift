import SwiftUI
import SwiftData

struct GoalSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Bindable var settings: TimerSettings
    let accentColor: Color
    
    @State private var selectedGoalPomodoros: Int
    @State private var selectedDays = Set<Int>()
    @State private var showAlert = false
    
    private let weekDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    init(settings: TimerSettings, accentColor: Color) {
        self.settings = settings
        self.accentColor = accentColor
        _selectedGoalPomodoros = State(initialValue: settings.dailyGoalPomodoros)
        _selectedDays = State(initialValue: Set(settings.activeDays))
    }
    
    var body: some View {
        PremiumFeatureView{
            
      
        NavigationView {
            Form {
                Section("Daily Goal") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Target Pomodoros: \(selectedGoalPomodoros)")
                            .foregroundColor(accentColor)
                        
                        Slider(value: .init(
                            get: { Double(selectedGoalPomodoros) },
                            set: { selectedGoalPomodoros = Int($0) }
                        ), in: 1...16, step: 1)
                            .tint(accentColor)
                    }
                    .padding(.vertical, 8)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recommended:")
                            .foregroundColor(.gray)
                        
                        HStack(spacing: 12) {
                            ForEach([8, 10, 12], id: \.self) { pomodoros in
                                Button(action: { selectedGoalPomodoros = pomodoros }) {
                                    Text("\(pomodoros) pomodoros")
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(accentColor, lineWidth: 1)
                                        )
                                        .background(
                                            selectedGoalPomodoros == pomodoros ?
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
    }
    
    private func toggleDay(_ day: Int) {
        if selectedDays.contains(day) {
            selectedDays.remove(day)
        } else {
            selectedDays.insert(day)
        }
    }
    
    private func saveSettings() {
        settings.dailyGoalPomodoros = selectedGoalPomodoros
        settings.activeDays = Array(selectedDays).sorted()
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Error saving settings: \(error)")
        }
    }
    
    private func resetProgress() {
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
