import SwiftUI

struct WaveTimerView: BaseTimerView {
    let timeRemaining: Int
    let progress: Double
    let accentColor: Color
    let isActive: Bool
    
    @State private var waveOffset = 0.0
    
    var body: some View {
        ZStack {
            // Wave background
            Circle()
                .fill(accentColor.opacity(0.2))
                .frame(width: 220, height: 220)
            
            // Water waves
            WaveShape(offset: waveOffset, percent: progress)
                .fill(accentColor.opacity(0.5))
                .frame(width: 220, height: 220)
                .clipShape(Circle())
            
            WaveShape(offset: waveOffset - 0.5, percent: progress)
                .fill(accentColor.opacity(0.3))
                .frame(width: 220, height: 220)
                .clipShape(Circle())
            
            // Time display
            VStack {
                Text("\(timeString.minutes):\(timeString.seconds)")
                    .font(.system(size: 50, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
            }
        }
        .frame(width: 250, height: 200)
        .onAppear {
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                waveOffset = 1
            }
        }
    }
}

struct WaveShape: Shape {
    var offset: Double
    var percent: Double
    
    var animatableData: Double {
        get { offset }
        set { offset = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let midHeight = height * (1 - percent)
        let wavelength = width / 2
        let amplitude: CGFloat = 10
        
        path.move(to: CGPoint(x: 0, y: height))
        
        for x in stride(from: 0, through: width, by: 1) {
            let relativeX = x / wavelength
            let sine = sin((relativeX + offset) * .pi * 2)
            let y = midHeight + sine * amplitude
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: width, y: height))
        path.closeSubpath()
        
        return path
    }
} 