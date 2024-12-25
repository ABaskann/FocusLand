import SwiftUI

struct MinimalTimerView: BaseTimerView {
    let timeRemaining: Int
    let progress: Double
    let accentColor: Color
    let isActive: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Text("\(timeString.minutes):\(timeString.seconds)")
                .font(.system(size: 80, weight: .thin, design: .rounded))
                .foregroundColor(accentColor)
            
            Rectangle()
                .fill(accentColor)
                .frame(width: 200 * progress, height: 2)
                .frame(width: 200, alignment: .leading)
        }
    }
} 