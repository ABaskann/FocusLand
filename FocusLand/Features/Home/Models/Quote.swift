import Foundation

struct Quote: Identifiable, Codable {
    let id: String
    let text: String
    let author: String
    var date: Date
    
    static let quotes = [
        Quote(id: "1", text: "The only way to do great work is to love what you do.", author: "Steve Jobs", date: Date()),
        Quote(id: "2", text: "Success is not final, failure is not fatal: it is the courage to continue that counts.", author: "Winston Churchill", date: Date()),
        Quote(id: "3", text: "Don't watch the clock; do what it does. Keep going.", author: "Sam Levenson", date: Date()),
        Quote(id: "4", text: "The future depends on what you do today.", author: "Mahatma Gandhi", date: Date()),
        Quote(id: "5", text: "Focus on being productive instead of busy.", author: "Tim Ferriss", date: Date()),
        Quote(id: "6", text: "It's not about having time, it's about making time.", author: "Unknown", date: Date()),
        Quote(id: "7", text: "The way to get started is to quit talking and begin doing.", author: "Walt Disney", date: Date()),
        Quote(id: "8", text: "Quality is not an act, it is a habit.", author: "Aristotle", date: Date()),
        Quote(id: "9", text: "Your time is limited, don't waste it living someone else's life.", author: "Steve Jobs", date: Date()),
        Quote(id: "10", text: "The only limit to our realization of tomorrow will be our doubts of today.", author: "Franklin D. Roosevelt", date: Date()),
        Quote(id: "11", text: "Start where you are. Use what you have. Do what you can.", author: "Arthur Ashe", date: Date()),
        Quote(id: "12", text: "The secret of getting ahead is getting started.", author: "Mark Twain", date: Date()),
        Quote(id: "13", text: "Don't count the days, make the days count.", author: "Muhammad Ali", date: Date()),
        Quote(id: "14", text: "Either you run the day or the day runs you.", author: "Jim Rohn", date: Date()),
        Quote(id: "15", text: "The only place where success comes before work is in the dictionary.", author: "Vidal Sassoon", date: Date()),
        Quote(id: "16", text: "Success usually comes to those who are too busy to be looking for it.", author: "Henry David Thoreau", date: Date()),
        Quote(id: "17", text: "The difference between try and triumph is just a little umph!", author: "Marvin Phillips", date: Date()),
        Quote(id: "18", text: "The expert in anything was once a beginner.", author: "Helen Hayes", date: Date()),
        Quote(id: "19", text: "Focus on the journey, not the destination.", author: "Greg Anderson", date: Date()),
        Quote(id: "20", text: "What you do today can improve all your tomorrows.", author: "Ralph Marston", date: Date()),
        Quote(id: "21", text: "Small progress is still progress.", author: "Unknown", date: Date()),
        Quote(id: "22", text: "The only bad workout is the one that didn't happen.", author: "Unknown", date: Date()),
        Quote(id: "23", text: "Dream big, start small, but most of all, start.", author: "Simon Sinek", date: Date()),
        Quote(id: "24", text: "Every accomplishment starts with the decision to try.", author: "Unknown", date: Date()),
        Quote(id: "25", text: "The harder you work for something, the greater you'll feel when you achieve it.", author: "Unknown", date: Date()),
        Quote(id: "26", text: "Don't stop when you're tired. Stop when you're done.", author: "Unknown", date: Date()),
        Quote(id: "27", text: "Success is built on daily habits.", author: "Unknown", date: Date()),
        Quote(id: "28", text: "Your future is created by what you do today.", author: "Unknown", date: Date()),
        Quote(id: "29", text: "Make each day your masterpiece.", author: "John Wooden", date: Date()),
        Quote(id: "30", text: "The only way to do great work is to love what you do.", author: "Steve Jobs", date: Date())
    ]
    
    static func getTodaysQuote() -> Quote {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let seed = calendar.component(.day, from: today) + 
                  calendar.component(.month, from: today) +
                  calendar.component(.year, from: today)
        
        let index = seed % quotes.count
        var quote = quotes[index]
        quote.date = today
        return quote
    }
} 
