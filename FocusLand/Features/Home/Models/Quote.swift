import Foundation

struct Quote: Identifiable, Codable {
    let id: String
    let text: String
    let author: String
    let date: Date
    
    // This is just for preview/placeholder data
    static let placeholder = Quote(
        id: "1",
        text: "The only way to do great work is to love what you do.",
        author: "Steve Jobs",
        date: Date()
    )
} 