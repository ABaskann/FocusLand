import SwiftUI

struct AnalogTimerView: BaseTimerView {
    let timeRemaining: Int
    let progress: Double
    let accentColor: Color
    let isActive: Bool
    
    private var totalMinutes: Int {
        timeRemaining / 60 + (timeRemaining % 60 == 0 ? 0 : 1)
    }
    
    private var startAngle: Double {
        // Convert minutes to clock position (15 min = 90 degrees, 30 min = 180 degrees, etc.)
        (Double(totalMinutes) / 60.0) * 360.0
    }
    
    private var currentAngle: Double {
        // Calculate current angle based on progress
        startAngle * (1 - progress)
    }
    
    var body: some View {
        ZStack {
            // Clock face
            Circle()
                .stroke(accentColor.opacity(0.2), lineWidth: 4)
                .frame(width: 200, height: 200)
            
            // Hour markers
            ForEach(0..<12) { hour in
                Rectangle()
                    .fill(accentColor.opacity(0.5))
                    .frame(width: 2, height: hour % 3 == 0 ? 15 : 8)
                    .offset(y: -90)
                    .rotationEffect(.degrees(Double(hour) * 30))
            }
            
            // Progress arc
            Circle()
                .trim(from: 1 - progress, to: 1)
                .stroke(
                    accentColor,
                    style: StrokeStyle(
                        lineWidth: 4,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .rotationEffect(.degrees(-startAngle))
                .frame(width: 200, height: 200)
            
            // Clock hand
            Rectangle()
                .fill(accentColor)
                .frame(width: 2, height: 80)
                .offset(y: -40)
                .rotationEffect(.degrees(currentAngle))
            
            // Center dot
            Circle()
                .fill(accentColor)
                .frame(width: 8, height: 8)
            
            // Digital time
            Text("\(timeString.minutes):\(timeString.seconds)")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(accentColor)
                .offset(y: 40)
        }
        .frame(width: 250, height: 200)
    }
} 