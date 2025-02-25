import SwiftUI

struct DailyQuoteView: View {
    let quote: Quote
    let accentColor: Color
    
    var localizedTitle: String {
        switch Locale(identifier: Locale.preferredLanguages.first!).language.languageCode?.identifier ?? "en" {
        case "es":
            return "Cita del Día"
        case "fr":
            return "Citation du Jour"
        case "de":
            return "Zitat des Tages"
        default:
            return "Daily Quote"
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Text(localizedTitle)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(accentColor)
            
            Text(quote.text)
                .font(.body)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.white)
            
            Text("- \(quote.author)")
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundColor(.gray)
        }
        .onAppear{
            print(Locale(identifier: Locale.preferredLanguages.first!).language.languageCode?.identifier)
            //print(Locale.current.language.languageCode?.identifier)
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(16)
    }
} 
