import Foundation

class QuoteService {
    static let shared = QuoteService()
    
    private init() {}
    
    func fetchDailyQuote() async throws -> Quote {
        // Replace this with your actual API call
        let url = URL(string: "YOUR_API_ENDPOINT")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Quote.self, from: data)
    }
} 