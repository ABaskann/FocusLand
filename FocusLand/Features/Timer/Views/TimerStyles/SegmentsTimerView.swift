import SwiftUI

struct SegmentsTimerView: BaseTimerView {
    let timeRemaining: Int
    let progress: Double
    let accentColor: Color
    let isActive: Bool
    
    private let numberOfSegments = 60
    
    var body: some View {
        ZStack {
            // Segments
            ForEach(0..<numberOfSegments, id: \.self) { index in
                let angle = Double(index) * (360.0 / Double(numberOfSegments))
                let shouldHighlight = Double(index) / Double(numberOfSegments) <= progress
                
                Rectangle()
                    .fill(shouldHighlight ? accentColor : accentColor.opacity(0.2))
                    .frame(width: 3, height: 15)
                    .offset(y: -100)
                    .rotationEffect(.degrees(angle))
            }
            
            // Time display
            Text("\(timeString.minutes):\(timeString.seconds)")
                .font(.system(size: 45, weight: .medium))
                .foregroundColor(accentColor)
        }
        .frame(width: 250, height: 250)
    }
} 