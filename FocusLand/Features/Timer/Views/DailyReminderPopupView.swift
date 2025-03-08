import SwiftUI

struct DailyReminderPopupView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var settings: TimerSettings
    let accentColor: Color
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "bell.badge.fill")
                .font(.system(size: 50))
                .foregroundColor(accentColor)
            
            Text("Enable Daily Reminders")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Never miss your daily focus sessions! Enable reminders to stay on track with your productivity goals.")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
            
            HStack(spacing: 16) {
                Button("Maybe Later") {
                    dismiss()
                }
                .foregroundColor(.gray)
                
                Button {
                    settings.isDailyReminderEnabled = true
                    dismiss()
                } label: {
                    Text("Enable")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 100)
                        .padding(.vertical, 12)
                        .background(accentColor)
                        .cornerRadius(8)
                }
            }
            .padding(.top)
        }
        .padding(32)
        .background(Color.black)
        .cornerRadius(16)
        .padding()
    }
} 