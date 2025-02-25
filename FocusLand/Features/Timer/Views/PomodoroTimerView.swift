import SwiftUI
import SwiftData
import RevenueCat
import RevenueCatUI
import GoogleMobileAds

struct PomodoroTimerView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(TimerManager.self) private var timerManager
    @Query private var settings: [TimerSettings]
    @Environment(SoundManager.self) private var soundManager
    @Environment(\.requestReview) var requestReview
    @AppStorage("times") var times: Int = 0
    @AppStorage("showReview") var showReview: Bool = true
    
    let adCoordinator = AdCoordinator()
    
    @State private var showingColorPicker = false
    @State private var showingSettings = false
    @State private var showPaywall = false
    
    @ObservedObject var userModel = UserViewModel.shared
    
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
    
    init() {
        
        adCoordinator.loadAd()
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                SessionIndicatorView(
                    currentPomodoro: timerManager.consecutiveWorkPeriods,
                    totalPomodoros: settings.first?.pomodorosBeforeLongBreak ?? 4,
                    isWorkTime: timerManager.isWorkTime,
                    accentColor: timerColor
                )
                .padding(.top, 40)
                
                Spacer()
                
                // Timer View
                Group {
                    switch settings.first?.timerStyleEnum ?? .circular {
                    case .circular:
                        CircularTimerView(
                            progress: progress,
                            timerColor: timerColor,
                            timeRemaining: timerManager.timeRemaining
                        )
                    case .minimal:
                        MinimalTimerView(
                            timeRemaining: timerManager.timeRemaining,
                            progress: progress,
                            accentColor: timerColor,
                            isActive: timerManager.isActive
                        )
                    case .modern:
                        ModernTimerView(
                            timeRemaining: timerManager.timeRemaining,
                            progress: progress,
                            accentColor: timerColor,
                            isActive: timerManager.isActive
                        )
                    case .classic:
                        ClassicTimerView(
                            timeRemaining: timerManager.timeRemaining,
                            progress: progress,
                            accentColor: timerColor,
                            isActive: timerManager.isActive
                        )
                    case .digital:
                        DigitalTimerView(
                            timeRemaining: timerManager.timeRemaining,
                            progress: progress,
                            accentColor: timerColor,
                            isActive: timerManager.isActive
                        )
                    case .analog:
                        AnalogTimerView(
                            timeRemaining: timerManager.timeRemaining,
                            progress: progress,
                            accentColor: timerColor,
                            isActive: timerManager.isActive
                        )
                    case .wave:
                        WaveTimerView(
                            timeRemaining: timerManager.timeRemaining,
                            progress: progress,
                            accentColor: timerColor,
                            isActive: timerManager.isActive
                        )
                    case .gradient:
                        GradientTimerView(
                            timeRemaining: timerManager.timeRemaining,
                            progress: progress,
                            accentColor: timerColor,
                            isActive: timerManager.isActive
                        )
                    case .segments:
                        SegmentsTimerView(
                            timeRemaining: timerManager.timeRemaining,
                            progress: progress,
                            accentColor: timerColor,
                            isActive: timerManager.isActive
                        )
                    case .retro:
                        RetroTimerView(
                            timeRemaining: timerManager.timeRemaining,
                            progress: progress,
                            accentColor: timerColor,
                            isActive: timerManager.isActive
                        )
                    }
                }
                
                Spacer()
                
                // Sound Control Section
                if soundManager.selectedSound != .none {
                    VStack(spacing: 16) {
                        Label(soundManager.selectedSound.name, systemImage: soundManager.selectedSound.icon)
                            .foregroundColor(timerColor)
                        
                        HStack(spacing: 12) {
                            Image(systemName: "speaker.fill")
                                .foregroundColor(timerColor)
                            
                            Slider(
                                value: .init(
                                    get: { soundManager.volume },
                                    set: { 
                                        soundManager.volume = $0
                                        soundManager.updateVolume()
                                    }
                                ),
                                in: 0...1
                            )
                            .tint(timerColor)
                            
                            Image(systemName: "speaker.wave.3.fill")
                                .foregroundColor(timerColor)
                        }
                    }
                    .padding(.horizontal, 40)
                }
                
                // Timer Controls
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
                }
                .padding(.bottom, 40)
                if(!userModel.subscriptionActive){
                    BannerView().frame(width: GADAdSizeBanner.size.width,height: GADAdSizeBanner.size.height).offset(y:-30)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .preferredColorScheme(.dark)
            .onChange(of: timerManager.isActive) { _, isActive in
                UIApplication.shared.isIdleTimerDisabled = isActive
                
                // Only play sound during work sessions
                if isActive && timerManager.isWorkTime && soundManager.selectedSound != .none {
                    soundManager.playSound()
                } else {
                    soundManager.stopSound()
                }
            }
            .onDisappear {
                UIApplication.shared.isIdleTimerDisabled = false
            }
            .onAppear{
               
                times += 1
                if(times == 1) {
                    requestReview()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    SoundMenuView(
                        showPaywall: $showPaywall,
                        timerColor: timerColor
                    )
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingSettings.toggle() }) {
                        Image(systemName: "gear.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(timerColor)
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                if let settings = settings.first {
                    TimerSettingsView(
                        settings: settings,
                        accentColor: timerColor,
                        shouldResetTimer: !timerManager.isActive // Only reset if timer is not active
                    )
                }
            }
        }
        .navigationViewStyle(.stack)
        .sheet(isPresented: $showingColorPicker) {
            ColorPickerView(
                selectedColor: Binding(
                    get: { timerColor },
                    set: { updateTimerColor(to: $0) }
                ),
                settings: settings.first ?? TimerSettings()
            )
        }
        .sheet(isPresented:$showPaywall) {
            PaywallView()
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
        if(timerManager.isWorkTime == false && !userModel.subscriptionActive){
            adCoordinator.presentAd()
        }
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
        
        // Stop sound when timer completes
        soundManager.stopSound()
        
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

