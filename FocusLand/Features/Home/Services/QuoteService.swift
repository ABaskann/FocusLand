import Foundation
import UserNotifications

class QuoteService {
    static let shared = QuoteService()
    
    private init() {
        setupDailyQuoteNotification()
    }
    
    func fetchDailyQuote() async -> Quote {
        return Quote.getTodaysQuote()
    }
    
    private func setupDailyQuoteNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Daily Inspiration"
        content.body = Quote.getTodaysQuote().text
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 9 // Send notification at 9 AM
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )
        
        let request = UNNotificationRequest(
            identifier: "dailyQuote",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling quote notification: \(error)")
            }
        }
    }
    
    func updateDailyQuoteNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyQuote"])
        setupDailyQuoteNotification()
    }
} 