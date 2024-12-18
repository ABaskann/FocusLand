import SwiftUI
import _SwiftData_SwiftUI

struct CircularTimerView: View {
    @Query private var settings: [TimerSettings]
    let progress: Double
    let timerColor: Color
    let timeRemaining: Int
    @Environment(TimerManager.self) private var timerManager
    
    private let numberOfSegments = 100
    private let segmentWidth: CGFloat = 2.5
    private let spacing: CGFloat = 2
    
    private var timeString: (minutes: String, seconds: String) {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return (
            String(format: "%02d", minutes),
            String(format: "%02d", seconds)
        )
    }
    
    private var segmentsToFill: Int {
        Int(Double(numberOfSegments) * progress)
    }
    
    private var statusInfo: (symbol: String, text: String) {
        if timerManager.isWorkTime {
            return ("brain.head.profile", "Focus")
        } else if timerManager.isLongBreak {
            return ("cup.and.saucer", "Long Break")
        } else {
            return ("figure.walk", "Break")
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Status Indicator
            HStack(spacing: 8) {
                Image(systemName: statusInfo.symbol)
                    .font(.system(size: 16, weight: .medium))
                Text(statusInfo.text)
                    .font(.system(size: 16, weight: .medium))
            }
            .foregroundStyle(timerColor)
            .padding(.vertical, 4)
            .padding(.horizontal, 16)
            .background(
                Capsule()
                    .fill(timerColor.opacity(0.1))
            )
            
            // Session Progress Indicator
            ZStack {
                // Background capsule
                Capsule()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 280, height: 22)
                
                // All session indicators
                HStack(spacing: 3) {
                    // Work and break sessions
                    ForEach(0..<7, id: \.self) { index in
                        if index.isMultiple(of: 2) {
                            // Work sessions
                            Capsule()
                                .fill(index/2 < timerManager.consecutiveWorkPeriods ? timerColor : Color.gray.opacity(0.5))
                                .frame(width: 35, height: 14)
                        } else {
                            // Break sessions
                            Capsule()
                                .fill(index/2 < timerManager.consecutiveWorkPeriods ? timerColor.opacity(0.5) : Color.gray.opacity(0.5))
                                .frame(width: 20, height: 14)
                        }
                    }
                    // Long break
                    Capsule()
                        .fill(timerManager.isLongBreak ? timerColor.opacity(0.5) : Color.gray.opacity(0.5))
                        .frame(width: 35, height: 14)
                }
                .padding(.horizontal, 8)
            }
            .background(
                Capsule()
                    .fill(Color.gray.opacity(0.05))
                    .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
            )
            .frame(width: 280, height: 22)
            
            // Timer Circle
            ZStack {
                // Segments
                ForEach(0..<numberOfSegments, id: \.self) { index in
                    let angle = Double(index) * (360.0 / Double(numberOfSegments))
                    let shouldHighlight = index <= segmentsToFill
                    
                    Capsule()
                        .fill(shouldHighlight ? timerColor : timerColor.opacity(0.2))
                        .frame(width: segmentWidth, height: 13)
                        .offset(y: -120)
                        .rotationEffect(.degrees(angle))
                }
                
                // Timer text container
                HStack(spacing: 4) {
                    Text(timeString.minutes)
                        .font(.system(size: 50, weight: .light, design: .rounded))
                    Text(":")
                        .font(.system(size: 50, weight: .light, design: .rounded))
                        .offset(y: -2)
                    Text(timeString.seconds)
                        .font(.system(size: 50, weight: .light, design: .rounded))
                }
                .foregroundColor(timerColor)
                .rotationEffect(.degrees(90))
            }
            .frame(width: 300, height: 300)
            .rotationEffect(.degrees(-90))
            .onChange(of: timeRemaining) {
                if timeRemaining == 0 {
                    timerManager.sessionCompleted(settings: settings.first)
                }
            }
        }
    }
} 
