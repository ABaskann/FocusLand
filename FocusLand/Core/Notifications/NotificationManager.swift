import UserNotifications
import SwiftUI

@Observable
class NotificationManager {
    static let shared = NotificationManager()
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleReminderNotification(at time: Date, onDays: Set<Int>, identifier: String = "dailyReminder") {
        let content = UNMutableNotificationContent()
        content.title = "Time to Focus!"
        content.body = getRandomQuote()
        content.sound = .default
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)
        
        // Create trigger for each selected day
        for weekday in onDays {
            var triggerComponents = DateComponents()
            triggerComponents.hour = components.hour
            triggerComponents.minute = components.minute
            triggerComponents.weekday = weekday // 1 = Sunday, 2 = Monday, etc.
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "\(identifier)_\(weekday)", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    func cancelReminders(identifier: String = "dailyReminder") {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    private func getRandomQuote() -> String {
        let quotes = [
            "Focus on being productive instead of busy.",
            "The secret of getting ahead is getting started.",
            "Don't wait for the perfect moment, take the moment and make it perfect.",
            "Small progress is still progress.",
            "Stay focused, go after your dreams, and keep moving toward your goals."
        ]
        return quotes.randomElement() ?? quotes[0]
    }
} 