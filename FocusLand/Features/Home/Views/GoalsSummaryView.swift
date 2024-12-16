import SwiftUI

struct GoalsSummaryView: View {
    let goal: Goal
    let accentColor: Color
    let streak: Int
    
    private var progressPercentage: Double {
        min(goal.progress * 100, 100)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Today's Progress Section
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Today's Goal")
                            .font(.headline)
                            .foregroundColor(accentColor)
                        
                        Text(String(format: "%.1f of %.1f hours", goal.completedHours, goal.targetHours))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Text(String(format: "%.0f%%", progressPercentage))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(accentColor)
                }
                
                // Progress Bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(accentColor.opacity(0.2))
                        
                        Rectangle()
                            .fill(accentColor)
                            .frame(width: geometry.size.width * CGFloat(goal.progress))
                    }
                }
                .frame(height: 8)
                .cornerRadius(4)
                
                // Status message
                Text(getStatusMessage())
                    .font(.caption)
                    .foregroundColor(getStatusColor())
            }
            
            // Streak Section
            VStack(alignment: .leading, spacing: 8) {
                Divider()
                    .background(Color.gray.opacity(0.3))
                
                HStack(spacing: 16) {
                    // Current Streak
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 6) {
                            Image(systemName: "flame.fill")
                                .foregroundColor(.accentColor)
                            Text("Current Streak")
                                .font(.subheadline)
                                .foregroundColor(.accentColor)
                        }
                        
                        Text("\(streak) day\(streak == 1 ? "" : "s")")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.accentColor)
                    }
                    
                    Spacer()
                    
                    // Streak Status
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(getStreakStatus())
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text(getStreakMessage())
                            .font(.caption)
                            .foregroundColor(.accentColor)
                    }
                }
            }
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(accentColor.opacity(0.3), lineWidth: 1)
        )
    }
    
    private func getStatusMessage() -> String {
        if goal.progress >= 1.0 {
            return "Goal completed! 🎉"
        } else if goal.progress >= 0.5 {
            return "More than halfway there! 💪"
        } else if goal.progress > 0 {
            return "Keep going! 🚀"
        } else {
            return "Start your focus session! ⏰"
        }
    }
    
    private func getStatusColor() -> Color {
        if goal.progress >= 1.0 {
            return .green
        } else if goal.progress >= 0.5 {
            return accentColor
        } else {
            return .gray
        }
    }
    
    private func getStreakStatus() -> String {
        if streak == 0 {
            return "No active streak"
        } else if goal.progress >= 0.8 {
            return "Streak secured!"
        } else {
            return "Complete today's goal"
        }
    }
    
    private func getStreakMessage() -> String {
        if streak == 0 {
            return "Start your streak today!"
        } else if streak < 3 {
            return "Keep it going!"
        } else if streak < 7 {
            return "You're on fire! 🔥"
        } else {
            return "Unstoppable! 🏆"
        }
    }
} 
