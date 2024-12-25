import SwiftUI

struct GradientTimerView: BaseTimerView {
    let timeRemaining: Int
    let progress: Double
    let accentColor: Color
    let isActive: Bool
    
    var body: some View {
        ZStack {
            // Background gradient circle
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [
                            accentColor.opacity(0.2),
                            accentColor.opacity(0.1)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 15
                )
                .frame(width: 220, height: 220)
            
            // Progress circle with dynamic gradient
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(stops: [
                            .init(color: accentColor.opacity(0.8), location: 0),
                            .init(color: accentColor, location: 0.4),
                            .init(color: accentColor.opacity(0.8), location: 1)
                        ]),
                        center: .center
                    ),
                    style: StrokeStyle(
                        lineWidth: 15,
                        lineCap: .round
                    )
                )
                .frame(width: 220, height: 220)
                .rotationEffect(.degrees(-90))
            
            // Inner circle with radial gradient
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            accentColor.opacity(0.2),
                            .clear
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 90
                    )
                )
                .frame(width: 180, height: 180)
            
            // Time display
            VStack(spacing: 4) {
                Text("\(timeString.minutes):\(timeString.seconds)")
                    .font(.system(size: 50, weight: .light, design: .rounded))
                    .foregroundColor(.white)
            }
        }
        .frame(width: 250, height: 200)
    }
} 
