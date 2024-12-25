import SwiftUI

struct DigitalTimerView: BaseTimerView {
    let timeRemaining: Int
    let progress: Double
    let accentColor: Color
    let isActive: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            // LED-style display
            Text("\(timeString.minutes):\(timeString.seconds)")
                .font(.system(size: 60, weight: .medium, design: .monospaced))
                .foregroundColor(accentColor)
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.black.opacity(0.6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(accentColor.opacity(0.5), lineWidth: 2)
                        )
                )
                .shadow(color: accentColor.opacity(0.3), radius: 10, x: 0, y: 0)
            
            // Progress dots
            HStack(spacing: 8) {
                ForEach(0..<10, id: \.self) { index in
                    Circle()
                        .fill(index < Int(progress * 10) ? accentColor : accentColor.opacity(0.2))
                        .frame(width: 8, height: 8)
                }
            }
        }
        .frame(width: 250, height: 200)
    }
} 