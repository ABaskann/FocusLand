import SwiftUI

struct Achievement: Identifiable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let color: Color
    let requirement: Int
    var isUnlocked: Bool
    var progress: Double
    
    static let all: [Achievement] = [
        // Streak Achievements
        Achievement(
            id: "streak3",
            title: "Getting Started",
            description: "Maintain a 3-day focus streak",
            icon: "flame",
            color: .orange,
            requirement: 3,
            isUnlocked: false,
            progress: 0
        ),
        Achievement(
            id: "streak7",
            title: "Focus Master",
            description: "Maintain a 7-day focus streak",
            icon: "flame.fill",
            color: .orange,
            requirement: 7,
            isUnlocked: false,
            progress: 0
        ),
        
        // Hours Focused Achievements
        Achievement(
            id: "hours10",
            title: "Time Warrior",
            description: "Complete 10 hours of focused work",
            icon: "clock.fill",
            color: .blue,
            requirement: 10,
            isUnlocked: false,
            progress: 0
        ),
        Achievement(
            id: "hours50",
            title: "Focus Champion",
            description: "Complete 50 hours of focused work",
            icon: "clock.badge.checkmark.fill",
            color: .blue,
            requirement: 50,
            isUnlocked: false,
            progress: 0
        ),
        
        // Goal Completion Achievements
        Achievement(
            id: "goals5",
            title: "Goal Getter",
            description: "Complete daily goals 5 times",
            icon: "target",
            color: .green,
            requirement: 5,
            isUnlocked: false,
            progress: 0
        ),
        Achievement(
            id: "goals20",
            title: "Goal Master",
            description: "Complete daily goals 20 times",
            icon: "crown",
            color: .green,
            requirement: 20,
            isUnlocked: false,
            progress: 0
        )
    ]
} 
