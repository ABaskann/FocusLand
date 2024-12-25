import SwiftUI

protocol BaseTimerView: View {
    var timeRemaining: Int { get }
    var progress: Double { get }
    var accentColor: Color { get }
    var isActive: Bool { get }
}

extension BaseTimerView {
    var timeString: (minutes: String, seconds: String) {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return (
            String(format: "%02d", minutes),
            String(format: "%02d", seconds)
        )
    }
} 