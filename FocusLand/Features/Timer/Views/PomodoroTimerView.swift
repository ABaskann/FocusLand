import SwiftUI
import SwiftData

struct PomodoroTimerView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var settings: [TimerSettings]
    
    @State private var timeRemaining: Int = 1500
    @State private var isActive = false
    @State private var isWorkTime = true
    @State private var showingColorPicker = false
    @State private var showingSettings = false
    @State private var consecutiveWorkPeriods = 0
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private var progress: Double {
        let total = isWorkTime ? 
            (settings.first?.shortWorkMode == true ? 
                settings.first?.shortWorkDuration ?? 5 : 
                settings.first?.workDuration ?? 25) * 60 : 
            settings.first?.breakDuration ?? 5 * 60
        return Double(total - timeRemaining) / Double(total)
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
                    timeRemaining: timeRemaining
                )
                
                HStack(spacing: 30) {
                    Button(action: toggleTimer) {
                        Image(systemName: isActive ? "pause.circle.fill" : "play.circle.fill")
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
                
                // Skip break button
                if !isWorkTime && settings.first?.canSkipBreaks == true {
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
            .navigationTitle("Focus Timer")
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
            guard isActive else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                handleTimerCompletion()
            }
        }
        .onAppear {
            if settings.isEmpty {
                let defaultSettings = TimerSettings()
                modelContext.insert(defaultSettings)
            }
            resetTimer()
        }
    }
    
    private func handleTimerCompletion() {
        isActive = false
        if isWorkTime {
            consecutiveWorkPeriods += 1
            isWorkTime = false
            resetTimer()
        } else {
            isWorkTime = true
            resetTimer()
        }
        // Here you could add notifications or sounds
    }
    
    private func skipBreak() {
        isWorkTime = true
        resetTimer()
    }
    
    private func toggleTimer() {
        isActive.toggle()
    }
    
    private func resetTimer() {
        if isWorkTime {
            timeRemaining = settings.first?.shortWorkMode == true ? 
                (settings.first?.shortWorkDuration ?? 5) * 60 : 
                (settings.first?.workDuration ?? 25) * 60
        } else {
            timeRemaining = (settings.first?.breakDuration ?? 5) * 60
        }
    }
    
    private func updateTimerColor(to color: Color) {
        if let settings = settings.first {
            settings.selectedColor = color.toHex() ?? "#FF9500"
        }
    }
} 
