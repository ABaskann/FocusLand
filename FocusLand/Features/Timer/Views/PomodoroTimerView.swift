import SwiftUI
import SwiftData

struct PomodoroTimerView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(TimerManager.self) private var timerManager
    @Query private var settings: [TimerSettings]
    
    @State private var showingColorPicker = false
    @State private var showingSettings = false
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private var progress: Double {
        let total = timerManager.isWorkTime ? 
            (settings.first?.shortWorkMode == true ? 
                settings.first?.shortWorkDuration ?? 5 : 
                settings.first?.workDuration ?? 25) * 60 : 
            settings.first?.breakDuration ?? 5 * 60
        return Double(total - timerManager.timeRemaining) / Double(total)
    }
    
    private var timerColor: Color {
        Color(hex: settings.first?.selectedColor ?? "#FF9500") ?? .orange
    }
    
    var body: some View {
        NavigationView {
            VStack {
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
                
                if !timerManager.isWorkTime && settings.first?.canSkipBreaks == true {
                    Button(action: skipBreak) {
                        Text("Skip Break")
                            .foregroundColor(timerColor)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(timerColor, lineWidth: 1)
                            )
                    }
                    .padding(.top, 20)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .preferredColorScheme(.dark)
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
    
    private func toggleTimer() {
        timerManager.isActive.toggle()
    }
    
    private func resetTimer() {
        timerManager.resetTimer(settings: settings.first)
    }
    
    private func skipBreak() {
        timerManager.isWorkTime = true
        resetTimer()
    }
    
    private func handleTimerCompletion() {
        timerManager.isActive = false
        if timerManager.isWorkTime {
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
            timerManager.isWorkTime = true
            resetTimer()
        }
    }
    
    private func updateTimerColor(to color: Color) {
        if let settings = settings.first {
            settings.selectedColor = color.toHex() ?? "#FF9500"
        }
    }
} 

