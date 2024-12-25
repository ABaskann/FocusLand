import SwiftUI

struct RetroTimerView: BaseTimerView {
    let timeRemaining: Int
    let progress: Double
    let accentColor: Color
    let isActive: Bool
    
    private let displayWidth: CGFloat = 220
    private let totalSegments = 20
    
    private var activeSegments: Int {
        // Ensure we have a valid range by clamping the progress value
        let clampedProgress = max(0, min(1, progress))
        return Int(round(clampedProgress * Double(totalSegments)))
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Retro LCD display
            Text("\(timeString.minutes):\(timeString.seconds)")
                .font(.system(size: 55, weight: .regular, design: .monospaced))
                .foregroundColor(accentColor)
                .frame(width: displayWidth)
                .padding(.vertical, 20)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(accentColor.opacity(0.3), lineWidth: 1)
                        )
                )
                .overlay(
                    // Scan line effect
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [.clear, accentColor.opacity(0.1), .clear],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .mask(
                            Rectangle()
                                .fill(.white)
                                .opacity(0.5)
                        )
                )
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background segments
                    HStack(spacing: 2) {
                        ForEach(0..<totalSegments, id: \.self) { _ in
                            Rectangle()
                                .fill(accentColor.opacity(0.2))
                                .frame(width: 8)
                        }
                    }
                    .frame(width: displayWidth)
                    
                    // Progress segments
                    HStack(spacing: 2) {
                        ForEach(0..<activeSegments, id: \.self) { _ in
                            Rectangle()
                                .fill(accentColor)
                                .frame(width: 8)
                        }
                    }
                }
            }
            .frame(width: displayWidth, height: 20)
        }
        .frame(width: 250, height: 200)
    }
} 