import SwiftUI

struct ModernTimerView: BaseTimerView {
    let timeRemaining: Int
    let progress: Double
    let accentColor: Color
    let isActive: Bool
    
    var body: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(accentColor.opacity(0.2), lineWidth: 30)
            
            // Progress ring
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [accentColor.opacity(0.5), accentColor]),
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360)
                    ),
                    style: StrokeStyle(lineWidth: 30, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
            
            // Time display
            VStack(spacing: 8) {
                Text("\(timeString.minutes):\(timeString.seconds)")
                    .font(.system(size: 60, weight: .light, design: .rounded))
                    .foregroundColor(accentColor)
            }
        }
        .frame(width: 300, height: 300)
    }
} 
