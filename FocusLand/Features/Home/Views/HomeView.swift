import SwiftUI

struct HomeView: View {
    @State private var currentQuote = Quote.placeholder
    @State private var isLoading = false
    @State private var error: Error?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Daily Quote Section
                    DailyQuoteView(
                        quote: currentQuote,
                        accentColor: .orange
                    )
                    .padding(.horizontal)
                    
                    // Focus Statistics Section
                    VStack(alignment: .leading) {
                        Text("Focus Statistics")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        // Add your statistics content here
                    }
                }
                .padding(.vertical)
            }
            .background(Color.black)
            .navigationTitle("Focus")
            .preferredColorScheme(.dark)
        }
        .task {
            await fetchQuote()
        }
    }
    
    private func fetchQuote() async {
        isLoading = true
        do {
            currentQuote = try await QuoteService.shared.fetchDailyQuote()
        } catch {
            self.error = error
            // Handle error appropriately
        }
        isLoading = false
    }
}

// Preview provider
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
} 