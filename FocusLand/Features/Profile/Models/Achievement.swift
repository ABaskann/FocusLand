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
        Achievement(
            id: "streak14",
            title: "Unstoppable",
            description: "Maintain a 14-day focus streak",
            icon: "flame.circle.fill",
            color: .orange,
            requirement: 14,
            isUnlocked: false,
            progress: 0
        ),
        Achievement(
            id: "streak30",
            title: "Focus Legend",
            description: "Maintain a 30-day focus streak",
            icon: "sparkles",
            color: .orange,
            requirement: 30,
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
            id: "hours25",
            title: "Focus Apprentice",
            description: "Complete 25 hours of focused work",
            icon: "clock.badge",
            color: .blue,
            requirement: 25,
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
        Achievement(
            id: "hours100",
            title: "Time Lord",
            description: "Complete 100 hours of focused work",
            icon: "clock.badge.fill",
            color: .blue,
            requirement: 100,
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
            icon: "scope",
            color: .green,
            requirement: 20,
            isUnlocked: false,
            progress: 0
        ),
        Achievement(
            id: "goals50",
            title: "Goal Champion",
            description: "Complete daily goals 50 times",
            icon: "crown.fill",
            color: .green,
            requirement: 50,
            isUnlocked: false,
            progress: 0
        ),
        Achievement(
            id: "goals100",
            title: "Goal Legend",
            description: "Complete daily goals 100 times",
            icon: "star.fill",
            color: .green,
            requirement: 100,
            isUnlocked: false,
            progress: 0
        ),
        
        // Session Achievements
        Achievement(
            id: "sessions10",
            title: "Focus Beginner",
            description: "Complete 10 focus sessions",
            icon: "hourglass",
            color: .purple,
            requirement: 10,
            isUnlocked: false,
            progress: 0
        ),
        Achievement(
            id: "sessions50",
            title: "Focus Expert",
            description: "Complete 50 focus sessions",
            icon: "hourglass.circle.fill",
            color: .purple,
            requirement: 50,
            isUnlocked: false,
            progress: 0
        ),
        Achievement(
            id: "sessions100",
            title: "Focus Elite",
            description: "Complete 100 focus sessions",
            icon: "hourglass.badge.plus",
            color: .purple,
            requirement: 100,
            isUnlocked: false,
            progress: 0
        ),
        Achievement(
            id: "sessions500",
            title: "Focus Grandmaster",
            description: "Complete 500 focus sessions",
            icon: "medal.fill",
            color: .purple,
            requirement: 500,
            isUnlocked: false,
            progress: 0
        ),
        
        // Perfect Week Achievements
        Achievement(
            id: "perfectWeek1",
            title: "Perfect Week",
            description: "Complete all daily goals for one week",
            icon: "calendar.badge.checkmark",
            color: .pink,
            requirement: 1,
            isUnlocked: false,
            progress: 0
        ),
        Achievement(
            id: "perfectWeek4",
            title: "Perfect Month",
            description: "Complete 4 perfect weeks",
            icon: "calendar.circle.fill",
            color: .pink,
            requirement: 4,
            isUnlocked: false,
            progress: 0
        ),
        Achievement(
            id: "perfectWeek12",
            title: "Perfect Quarter",
            description: "Complete 12 perfect weeks",
            icon: "calendar.badge.clock",
            color: .pink,
            requirement: 12,
            isUnlocked: false,
            progress: 0
        ),
        Achievement(
            id: "perfectWeek52",
            title: "Perfect Year",
            description: "Complete 52 perfect weeks",
            icon: "moon.stars",
            color: .pink,
            requirement: 52,
            isUnlocked: false,
            progress: 0
        )
    ]
} 
