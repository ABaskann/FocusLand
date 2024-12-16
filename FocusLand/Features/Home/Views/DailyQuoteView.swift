import SwiftUI

struct DailyQuoteView: View {
    let quote: Quote
    let accentColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Daily Inspiration")
                    .font(.headline)
                    .foregroundColor(accentColor)
                
                Spacer()
                
                Image(systemName: "quote.bubble.fill")
                    .foregroundColor(accentColor)
            }
            
            Text(quote.text)
                .font(.system(.body, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
            
            HStack {
                Text("— \(quote.author)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()
            }
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(accentColor.opacity(0.3), lineWidth: 1)
        )
    }
} 