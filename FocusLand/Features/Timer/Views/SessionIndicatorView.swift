import SwiftUI

struct SessionIndicatorView: View {
    let currentPomodoro: Int
    let totalPomodoros: Int
    let isWorkTime: Bool
    let accentColor: Color
    
    var body: some View {
        VStack(spacing: 16) {
            // Session type indicator
            Label(
                isWorkTime ? "Focus" : "Break",
                systemImage: isWorkTime ? "brain.head.profile" : "cup.and.saucer.fill"
            )
            .font(.headline)
            .foregroundColor(accentColor)
            .padding(.horizontal, 24)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(Color.black.opacity(0.3))
            )
            
            // Pomodoro progress indicators
            HStack(spacing: 8) {
                ForEach(0..<totalPomodoros, id: \.self) { index in
                    Circle()
                        .fill(index < currentPomodoro ? accentColor : Color.gray.opacity(0.3))
                        .frame(width: 12, height: 12)
                }
            }
        }
    }
} 