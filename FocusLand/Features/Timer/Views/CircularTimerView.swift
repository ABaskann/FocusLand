import SwiftUI
import _SwiftData_SwiftUI

struct CircularTimerView: View {
    @Query private var settings: [TimerSettings]
    let progress: Double
    let timerColor: Color
    let timeRemaining: Int
    
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
        // Calculate segments to fill based on current progress
        Int(Double(numberOfSegments) * progress)
    }
    
    var body: some View {
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
                    .offset(y: -2) // Adjust colon position
                Text(timeString.seconds)
                    .font(.system(size: 50, weight: .light, design: .rounded))
            }
            .foregroundColor(timerColor)
            .rotationEffect(.degrees(90))
        }
        .frame(width: 300, height: 300)
        .rotationEffect(.degrees(-90))
    }
} 
