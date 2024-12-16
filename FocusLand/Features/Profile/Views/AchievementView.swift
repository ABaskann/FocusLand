import SwiftUI

struct AchievementView: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 12) {
            // Badge Icon
            ZStack {
                Circle()
                    .fill(achievement.color.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Circle()
                    .stroke(
                        achievement.color.opacity(0.5),
                        lineWidth: 2
                    )
                    .frame(width: 60, height: 60)
                
                Image(systemName: achievement.icon)
                    .font(.system(size: 24))
                    .foregroundColor(achievement.isUnlocked ? achievement.color : .gray)
            }
            .overlay(
                Circle()
                    .trim(from: 0, to: achievement.progress)
                    .stroke(
                        achievement.color,
                        style: StrokeStyle(
                            lineWidth: 2,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
                    .frame(width: 60, height: 60)
            )
            
            VStack(spacing: 4) {
                Text(achievement.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(achievement.isUnlocked ? .white : .gray)
                
                Text(achievement.description)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(width: 120)
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(achievement.color.opacity(0.3), lineWidth: 1)
        )
    }
} 