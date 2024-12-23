import SwiftUI
import SwiftData
import UserNotifications

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Bindable var settings: TimerSettings
    
    private let themeColors: [(name: String, color: Color, hex: String)] = [
        ("Orange", .orange, "#FF9500"),
        ("Blue", .blue, "#0A84FF"),
        ("Green", .green, "#32D74B"),
        ("Purple", .purple, "#BF5AF2"),
        ("Pink", .pink, "#FF375F"),
        ("Red", .red, "#FF3B30"),
        ("Yellow", .yellow, "#FFD60A"),
        ("Mint", .mint, "#00C7BE")
    ]
    
    private func updateThemeColor(_ color: Color, hex: String) {
        settings.selectedColor = hex
        try? modelContext.save()
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Theme") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(themeColors, id: \.name) { theme in
                                ThemeButton(
                                    color: theme.color,
                                    isSelected: settings.selectedColor == theme.hex
                                ) {
                                    updateThemeColor(theme.color, hex: theme.hex)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                Section("App Settings") {
                    NavigationLink(destination: GoalSettingsView(settings: settings, accentColor: Color(hex: settings.selectedColor) ?? .orange)) {
                        Label("Focus Goals", systemImage: "target")
                    }
                    
                    NavigationLink(destination: NotificationSettingsView(settings: settings)) {
                        Label("Notifications", systemImage: "bell")
                    }
                }
                
                Section("About") {
                    Link(destination: URL(string: "https://yourapp.com/privacy")!) {
                        Label("Privacy Policy", systemImage: "lock.shield")
                    }
                    
                    Link(destination: URL(string: "https://yourapp.com/terms")!) {
                        Label("Terms of Service", systemImage: "doc.text")
                    }
                    
                    HStack {
                        Label("Version", systemImage: "info.circle")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ThemeButton: View {
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Outer selection circle
                Circle()
                    .stroke(color, lineWidth: isSelected ? 2 : 0)
                    .frame(width: 48, height: 48)
                
                // Color circle
                Circle()
                    .fill(color)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: isSelected ? 2 : 0)
                    )
                
                // Checkmark for selected color
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .animation(.easeInOut, value: isSelected)
        }
    }
}

struct NotificationSettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var settings: TimerSettings
    @State private var showingTimePicker = false
    
    var body: some View {
        Form {
            Section {
                Toggle("Enable Notifications", isOn: $settings.isNotificationsEnabled)
            } footer: {
                Text("Control all notification settings for FocusLand")
            }
            
            if settings.isNotificationsEnabled {
                Section {
                    Toggle("Session Completion", isOn: $settings.isTimerCompletionEnabled)
                        .onChange(of: settings.isTimerCompletionEnabled) { _, isEnabled in
                            if isEnabled {
                                requestTimerNotificationPermission()
                            }
                        }
                    
                    Toggle("Daily Reminder", isOn: $settings.isDailyReminderEnabled)
                        .onChange(of: settings.isDailyReminderEnabled) { _, isEnabled in
                            if isEnabled {
                                showingTimePicker = true
                                scheduleDailyReminder()
                            } else {
                                cancelDailyReminder()
                            }
                        }
                    
                    if settings.isDailyReminderEnabled {
                        DatePicker(
                            "Reminder Time",
                            selection: $settings.dailyReminderTime,
                            displayedComponents: .hourAndMinute
                        )
                        .onChange(of: settings.dailyReminderTime) { _, _ in
                            scheduleDailyReminder()
                        }
                    }
                } header: {
                    Text("Timer Notifications")
                } footer: {
                    Text("Get notified when your focus sessions end and receive daily reminders to stay on track")
                }
                
                Section {
                    Toggle("Daily Goal Progress", isOn: $settings.isDailyGoalEnabled)
                    Toggle("Streak Updates", isOn: $settings.isStreakEnabled)
                } header: {
                    Text("Goal Notifications")
                } footer: {
                    Text("Receive updates about your daily goals and streak achievements")
                }
            }
        }
        .navigationTitle("Notifications")
        .onAppear {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                if settings.authorizationStatus == .notDetermined {
                    requestNotificationPermission()
                }
            }
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error)")
            }
            if !granted {
                settings.isNotificationsEnabled = false
            }
        }
    }
    
    private func requestTimerNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            if !granted {
                DispatchQueue.main.async {
                    settings.isTimerCompletionEnabled = false
                }
            }
        }
    }
    
    private func scheduleDailyReminder() {
        guard settings.isDailyReminderEnabled else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Time to Focus!"
        content.body = "Start your day with a focused mindset 🎯"
        content.sound = .default
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: settings.dailyReminderTime)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    private func cancelDailyReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyReminder"])
    }
} 