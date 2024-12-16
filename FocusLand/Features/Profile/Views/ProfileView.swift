import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var focusSessions: [FocusSession]
    @Query private var settings: [TimerSettings]
    @State private var showingSettings = false
    
    private var accentColor: Color {
        Color(hex: settings.first?.selectedColor ?? "#FF9500") ?? .orange
    }
    
    private var goals: [Goal] {
        let calendar = Calendar.current
        let today = Date()
        let dailyGoal = settings.first?.dailyGoalHours ?? 4.0
        let activeDays = settings.first?.activeDays ?? Array(1...5)
        
        return (0..<7).map { dayOffset in
            let date = calendar.date(byAdding: .day, value: -dayOffset, to: today)!
            let dayStart = calendar.startOfDay(for: date)
            let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart)!
            
            let weekday = calendar.component(.weekday, from: date) - 1
            let isActiveDay = activeDays.contains(weekday)
            
            let daysSessions = focusSessions.filter { session in
                session.date >= dayStart && session.date < dayEnd && session.isCompleted
            }
            
            let completedMinutes = daysSessions.reduce(0) { $0 + $1.duration }
            
            return Goal(
                id: UUID(),
                title: dayName(for: date),
                targetHours: isActiveDay ? dailyGoal : 0,
                completedMinutes: completedMinutes,
                date: date
            )
        }.reversed()
    }
    
    private var todayGoal: Goal {
        goals.last ?? Goal(
            id: UUID(),
            title: "Today",
            targetHours: settings.first?.dailyGoalHours ?? 4.0,
            completedMinutes: 0,
            date: Date()
        )
    }
    
    private var currentStreak: Int {
        var streak = 0
        let calendar = Calendar.current
        
        let completedGoals = goals.filter { goal in
            let isActiveDay = settings.first?.activeDays.contains(
                calendar.component(.weekday, from: goal.date) - 1
            ) ?? false
            return goal.progress >= 0.8 && isActiveDay
        }.sorted { $0.date > $1.date }
        
        guard let lastCompletedDate = completedGoals.first?.date else {
            return 0
        }
        
        let today = calendar.startOfDay(for: Date())
        let lastCompleted = calendar.startOfDay(for: lastCompletedDate)
        
        guard calendar.dateComponents([.day], from: lastCompleted, to: today).day ?? 0 <= 1 else {
            return 0
        }
        
        var currentDate = lastCompleted
        
        for goal in completedGoals {
            let goalDate = calendar.startOfDay(for: goal.date)
            let dayDifference = calendar.dateComponents([.day], from: goalDate, to: currentDate).day ?? 0
            
            if dayDifference <= 1 {
                streak += 1
                currentDate = goalDate
            } else {
                break
            }
        }
        
        return streak
    }
    
    private func dayName(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
    
    private var achievements: [Achievement] {
        // Calculate total focused hours
        let totalMinutes = focusSessions.reduce(0) { $0 + $1.duration }
        let totalHours = Double(totalMinutes) / 60.0
        
        // Calculate completed goals
        let completedGoals = goals.filter { $0.progress >= 0.8 }.count
        
        return Achievement.all.map { achievement in
            var updated = achievement
            
            // Update achievement progress and status
            switch achievement.id {
            case "streak3", "streak7":
                updated.progress = Double(currentStreak) / Double(achievement.requirement)
                updated.isUnlocked = currentStreak >= achievement.requirement
                
            case "hours10", "hours50":
                updated.progress = totalHours / Double(achievement.requirement)
                updated.isUnlocked = totalHours >= Double(achievement.requirement)
                
            case "goals5", "goals20":
                updated.progress = Double(completedGoals) / Double(achievement.requirement)
                updated.isUnlocked = completedGoals >= achievement.requirement
            default:
                break
            }
            
            return updated
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    VStack(spacing: 8) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(accentColor)
                        
                        Text("Focus Profile")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .padding(.vertical)
                    
                    // Goal Summary
                    GoalsSummaryView(
                        goal: todayGoal,
                        accentColor: accentColor,
                        streak: currentStreak
                    )
                    .padding(.horizontal)
                    
                    // Achievements Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Achievements")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 16) {
                                ForEach(achievements) { achievement in
                                    AchievementView(achievement: achievement)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Additional Stats
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Statistics")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        // Add more stats here
                    }
                }
                .padding(.vertical)
            }
            .background(Color.black)
            .navigationTitle("Profile")
            .preferredColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingSettings.toggle() }) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(accentColor)
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                if let settings = settings.first {
                    SettingsView(settings: settings)
                }
            }
        }
    }
} 