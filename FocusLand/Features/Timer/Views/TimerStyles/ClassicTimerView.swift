import SwiftUI

struct ClassicTimerView: BaseTimerView {
    let timeRemaining: Int
    let progress: Double
    let accentColor: Color
    let isActive: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            // Digital display
            Text("\(timeString.minutes):\(timeString.seconds)")
                .font(.system(size: 70, weight: .light, design: .monospaced))
                .foregroundColor(accentColor)
            
            // Classic progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(accentColor.opacity(0.2))
                        .frame(height: 4)
                    
                    Rectangle()
                        .fill(accentColor)
                        .frame(width: geometry.size.width * progress, height: 4)
                }
            }
            .frame(width: 250, height: 4)
        }
        .frame(width: 250, height: 200)
    }
} 