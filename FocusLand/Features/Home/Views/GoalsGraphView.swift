import SwiftUI

struct GoalsGraphView: View {
    let goals: [Goal]
    let accentColor: Color
    @State private var selectedGoal: Goal?
    @State private var isShowingDetails = false
    
    private var maxValue: Double {
        goals.map { max($0.targetHours, $0.completedHours) }.max() ?? 4
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weekly Progress")
                .font(.headline)
                .foregroundColor(accentColor)
            
            HStack(alignment: .bottom, spacing: 12) {
                ForEach(goals) { goal in
                    VStack(spacing: 8) {
                        // Bar
                        VStack(spacing: 2) {
                            // Target indicator
                            Rectangle()
                                .fill(accentColor.opacity(0.3))
                                .frame(height: 2)
                                .offset(y: -getHeight(for: goal.targetHours))
                            
                            // Actual progress bar
                            RoundedRectangle(cornerRadius: 4)
                                .fill(accentColor)
                                .frame(width: 20, height: getHeight(for: goal.completedHours))
                        }
                        .onTapGesture {
                            selectedGoal = goal
                            isShowingDetails = true
                        }
                        
                        // Day label
                        Text(goal.title.prefix(3))
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
            }
            .frame(height: 200)
            
            // Stats summary
            if let selected = selectedGoal {
                VStack(alignment: .leading, spacing: 8) {
                    Text(selected.title)
                        .font(.headline)
                        .foregroundColor(accentColor)
                    
                    HStack(spacing: 16) {
                        StatItem(
                            title: "Completed",
                            value: String(format: "%.1f hrs", selected.completedHours)
                        )
                        
                        StatItem(
                            title: "Target",
                            value: String(format: "%.1f hrs", selected.targetHours)
                        )
                        
                        StatItem(
                            title: "Progress",
                            value: String(format: "%.0f%%", selected.progress * 100)
                        )
                    }
                }
                .padding(.top, 8)
            }
            
            // Legend
            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(accentColor)
                        .frame(width: 12, height: 12)
                    Text("Completed")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                HStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(accentColor.opacity(0.3))
                        .frame(width: 12, height: 2)
                    Text("Target")
                        .font(.caption)
                        .foregroundColor(.gray)
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
    
    private func getHeight(for value: Double) -> CGFloat {
        CGFloat(value / maxValue) * 180
    }
}

struct StatItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.subheadline)
                .foregroundColor(.white)
        }
    }
} 