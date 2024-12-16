import SwiftUI
import SwiftData

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
                    NavigationLink {
                        GoalSettingsView(settings: settings, accentColor: Color(hex: settings.selectedColor) ?? .orange)
                    } label: {
                        Label("Focus Goals", systemImage: "target")
                    }
                    
                    NavigationLink {
                        NotificationSettingsView()
                    } label: {
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
    @AppStorage("notificationsEnabled") private var notificationsEnabled = false
    
    var body: some View {
        Form {
            Section {
                Toggle("Enable Notifications", isOn: $notificationsEnabled)
                
                if notificationsEnabled {
                    Toggle("Goal Reminders", isOn: .constant(true))
                    Toggle("Achievement Alerts", isOn: .constant(true))
                    Toggle("Daily Summary", isOn: .constant(true))
                }
            }
        }
        .navigationTitle("Notifications")
    }
} 