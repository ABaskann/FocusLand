import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var focusSessions: [FocusSession]
    @Query private var settings: [TimerSettings]
    @State private var currentQuote: Quote = Quote.getTodaysQuote()
    @State private var isLoading = false
    @State private var selectedTimeFrame = 0
    @State private var showingGoalSettings = false
    
    private let timeFrames = ["Daily", "Weekly"]
    private var accentColor: Color {
        Color(hex: settings.first?.selectedColor ?? "#FF9500") ?? .orange
    }
    
    private var goals: [Goal] {
        let calendar = Calendar.current
        let today = Date()
        let dailyGoal = Double(settings.first?.dailyGoalPomodoros ?? 8) * 25.0 / 60.0
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
    
    private func dayName(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
    
    private var todayGoal: Goal {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: Date()) - 1
        let isActiveDay = settings.first?.activeDays.contains(weekday) ?? false
        
        if !isActiveDay {
            return Goal(
                id: UUID(),
                title: "Today",
                targetHours: 0,
                completedMinutes: 0,
                date: Date()
            )
        }
        
        return goals.last ?? Goal(
            id: UUID(),
            title: "Today",
            targetHours: Double(settings.first?.dailyGoalPomodoros ?? 8) * 25.0 / 60.0,
            completedMinutes: 0,
            date: Date()
        )
    }
    
    private var currentStreak: Int {
        var streak = 0
        let calendar = Calendar.current
        
        // Get all completed goals sorted by date
        let completedGoals = goals.filter { goal in
            // Consider a goal completed if progress is >= 80%
            let isActiveDay = settings.first?.activeDays.contains(
                calendar.component(.weekday, from: goal.date) - 1
            ) ?? false
            return goal.progress >= 0.8 && isActiveDay
        }.sorted { $0.date > $1.date }
        
        guard let lastCompletedDate = completedGoals.first?.date else {
            return 0
        }
        
        // Check if the streak is still active (includes today or yesterday)
        let today = calendar.startOfDay(for: Date())
        let lastCompleted = calendar.startOfDay(for: lastCompletedDate)
        
        guard calendar.dateComponents([.day], from: lastCompleted, to: today).day ?? 0 <= 1 else {
            return 0
        }
        
        // Count consecutive days
        var currentDate = lastCompleted
        
        for goal in completedGoals {
            let goalDate = calendar.startOfDay(for: goal.date)
            let dayDifference = calendar.dateComponents([.day], from: goalDate, to: currentDate).day ?? 0
            
            // Check if this goal is part of the streak
            if dayDifference <= 1 {
                streak += 1
                currentDate = goalDate
            } else {
                break
            }
        }
        
        return streak
    }
    
    private var displayedGoals: [Goal] {
        switch selectedTimeFrame {
        case 0: // Daily
            return [todayGoal] // Show only today's goal
        case 1: // Weekly
            return goals // Show all goals for the week
        default:
            return goals
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Daily Quote Section
                    DailyQuoteView(
                        quote: currentQuote,
                        accentColor: accentColor
                    )
                    .padding(.horizontal)
                    PremiumFeatureView{
                        
                        
                        // Goals Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Focus History")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Button(action: {
                                    if settings.isEmpty {
                                        let defaultSettings = TimerSettings()
                                        modelContext.insert(defaultSettings)
                                    }
                                    showingGoalSettings = true
                                }) {
                                    Label("Set Goal", systemImage: "target")
                                        .foregroundColor(accentColor)
                                }
                                
                                Picker("Time Frame", selection: $selectedTimeFrame) {
                                    ForEach(0..<timeFrames.count, id: \.self) { index in
                                        Text(timeFrames[index])
                                            .tag(index)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .frame(width: 150)
                            }
                            .padding(.horizontal)
                            
                            // Goals Graph
                            if selectedTimeFrame == 0 {
                                // Daily View
                                DailyGoalView(
                                    goal: todayGoal,
                                    accentColor: accentColor
                                )
                                .padding(.horizontal)
                            } else {
                                // Weekly View
                                PremiumFeatureView {
                                    GoalsGraphView(
                                        goals: goals,
                                        accentColor: accentColor
                                    )
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .background(Color.black)
            //            .navigationTitle("Focus")
            .preferredColorScheme(.dark)
            .onAppear {
                if settings.isEmpty {
                    let defaultSettings = TimerSettings()
                    modelContext.insert(defaultSettings)
                    try? modelContext.save()
                }
            }
            .sheet(isPresented: $showingGoalSettings) {
                if let settings = settings.first {
                    GoalSettingsView(
                        settings: settings,
                        accentColor: accentColor
                    )
                }
            }
        }
        .navigationViewStyle(.stack)
        .task {
            await fetchQuote()
        }
    }
    
    private func fetchQuote() async {
        isLoading = true
        currentQuote = await QuoteService.shared.fetchDailyQuote()
        isLoading = false
    }
}

// Preview provider
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

// New DailyGoalView
struct DailyGoalView: View {
    let goal: Goal
    let accentColor: Color
    
    private var isRestDay: Bool {
        goal.targetHours == 0
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(goal.title)
                        .font(.headline)
                    if isRestDay {
                        Text("Time to recharge!")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    } else {
                        Text(String(format: "%.1f of %.1f hours", goal.completedHours, goal.targetHours))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                if !isRestDay {
                    Text(String(format: "%.0f%%", goal.progress * 100))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(accentColor)
                }
            }
            
            if !isRestDay {
                // Progress Bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(accentColor.opacity(0.2))
                            .frame(height: 8)
                            .cornerRadius(4)
                        
                        Rectangle()
                            .fill(accentColor)
                            .frame(width: geometry.size.width * goal.progress, height: 8)
                            .cornerRadius(4)
                    }
                }
                .frame(height: 8)
            }
            
            // Status Message
            HStack {
                Image(systemName: isRestDay ? "moon.stars.fill" : getStatusIcon())
                    .foregroundColor(isRestDay ? .purple : getStatusColor())
                Text(isRestDay ? "Rest day - Take time to recharge" : getStatusMessage())
                    .font(.caption)
                    .foregroundColor(isRestDay ? .purple : getStatusColor())
            }
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(15)
    }
    
    private func getStatusIcon() -> String {
        if goal.progress >= 1.0 {
            return "checkmark.circle.fill"
        } else if goal.progress >= 0.5 {
            return "arrow.up.circle.fill"
        } else {
            return "arrow.right.circle.fill"
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
    
    private func getStatusMessage() -> String {
        if goal.progress >= 1.0 {
            return "Goal completed!"
        } else if goal.progress >= 0.5 {
            return "More than halfway there!"
        } else if goal.progress > 0 {
            return "Keep going!"
        } else {
            return "Start your focus session!"
        }
    }
}
