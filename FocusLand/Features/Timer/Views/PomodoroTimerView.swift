import SwiftUI
import SwiftData

struct PomodoroTimerView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(TimerManager.self) private var timerManager
    @Query private var settings: [TimerSettings]
    
    @State private var showingColorPicker = false
    @State private var showingSettings = false
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private let softHaptic = UIImpactFeedbackGenerator(style: .soft)
    private let mediumHaptic = UIImpactFeedbackGenerator(style: .medium)
    private let rigidHaptic = UIImpactFeedbackGenerator(style: .rigid)
    private let notificationHaptic = UINotificationFeedbackGenerator()
    
    private var progress: Double {
        let total = if timerManager.isWorkTime {
            (settings.first?.workDuration ?? 25) * 60
        } else if timerManager.consecutiveWorkPeriods >= (settings.first?.pomodorosBeforeLongBreak ?? 4) {
            (settings.first?.longBreakDuration ?? 15) * 60
        } else {
            (settings.first?.shortBreakDuration ?? 5) * 60
        }
        return Double(total - timerManager.timeRemaining) / Double(total)
    }
    
    private var timerColor: Color {
        Color(hex: settings.first?.selectedColor ?? "#FF9500") ?? .orange
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SessionIndicatorView(
                    currentPomodoro: timerManager.consecutiveWorkPeriods,
                    totalPomodoros: settings.first?.pomodorosBeforeLongBreak ?? 4,
                    isWorkTime: timerManager.isWorkTime,
                    accentColor: timerColor
                )
                .padding(.top)
                
                CircularTimerView(
                    progress: progress,
                    timerColor: timerColor,
                    timeRemaining: timerManager.timeRemaining
                )
                
                HStack(spacing: 30) {
                    Button(action: toggleTimer) {
                        Image(systemName: timerManager.isActive ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(timerColor)
                    }
                    
                    Button(action: resetTimer) {
                        Image(systemName: "arrow.clockwise.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(timerColor)
                    }
                    
                    Button(action: { showingColorPicker.toggle() }) {
                        Image(systemName: "paintpalette.fill")
                            .font(.system(size: 40))
                            .foregroundColor(timerColor)
                    }
                }
                
                // Removed skip break button since it's not part of the Pomodoro technique
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .preferredColorScheme(.dark)
            .onChange(of: timerManager.isActive) { _, isActive in
                UIApplication.shared.isIdleTimerDisabled = isActive
            }
            .onDisappear {
                UIApplication.shared.isIdleTimerDisabled = false
            }
//            .navigationTitle(timerTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingSettings.toggle() }) {
                        Image(systemName: "gear.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(timerColor)
                    }
                }
            }
        }
        .sheet(isPresented: $showingColorPicker) {
            ColorPickerView(selectedColor: Binding(
                get: { timerColor },
                set: { updateTimerColor(to: $0) }
            ))
        }
        .sheet(isPresented: $showingSettings) {
            TimerSettingsView(
                settings: settings.first ?? TimerSettings(),
                accentColor: timerColor
            )
        }
        .onReceive(timer) { _ in
            guard timerManager.isActive else { return }
            if timerManager.timeRemaining > 0 {
                timerManager.timeRemaining -= 1
            } else {
                handleTimerCompletion()
            }
        }
        .onAppear {
            if settings.isEmpty {
                let defaultSettings = TimerSettings()
                modelContext.insert(defaultSettings)
            }
            if timerManager.timeRemaining == 0 {
                resetTimer()
            }
        }
    }
    
    private var timerTitle: String {
        if timerManager.isWorkTime {
            return "Pomodoro \(timerManager.consecutiveWorkPeriods + 1)"
        } else if timerManager.consecutiveWorkPeriods >= (settings.first?.pomodorosBeforeLongBreak ?? 4) {
            return "Long Break"
        } else {
            return "Short Break"
        }
    }
    
    private func toggleTimer() {
        timerManager.isActive.toggle()
        UIApplication.shared.isIdleTimerDisabled = timerManager.isActive
        softHaptic.impactOccurred()
    }
    
    private func resetTimer() {
        timerManager.resetTimer(settings: settings.first)
        mediumHaptic.impactOccurred()
    }
    
    private func handleTimerCompletion() {
        timerManager.isActive = false
        if timerManager.isWorkTime {
            notificationHaptic.notificationOccurred(.success)
            
            if settings.first?.isTimerCompletionEnabled ?? false {
                scheduleCompletionNotification(isWorkTime: true)
            }
            
            let session = FocusSession(
                duration: (settings.first?.workDuration ?? 25),
                date: Date(),
                isCompleted: true
            )
            modelContext.insert(session)
            
            timerManager.consecutiveWorkPeriods += 1
            timerManager.isWorkTime = false
            resetTimer()
        } else {
            rigidHaptic.impactOccurred()
            
            if settings.first?.isTimerCompletionEnabled ?? false {
                scheduleCompletionNotification(isWorkTime: false)
            }
            
            timerManager.isWorkTime = true
            resetTimer()
        }
    }
    
    private func scheduleCompletionNotification(isWorkTime: Bool) {
        let content = UNMutableNotificationContent()
        content.title = isWorkTime ? "Focus Session Complete! 🎉" : "Break Time Over!"
        content.body = isWorkTime ? "Time for a well-deserved break." : "Ready to focus again?"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    private func updateTimerColor(to color: Color) {
        if let settings = settings.first {
            settings.selectedColor = color.toHex() ?? "#FF9500"
        }
    }
} 

