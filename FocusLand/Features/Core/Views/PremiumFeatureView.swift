import SwiftUI
import _SwiftData_SwiftUI
import RevenueCat
import RevenueCatUI

struct PremiumFeatureView<Content: View>: View {
    @ObservedObject private var userViewModel = UserViewModel.shared
    @State private var showingPaywall = false
    @Query private var settings: [TimerSettings]
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    private var accentColor: Color {
        Color(hex: settings.first?.selectedColor ?? "#FF9500") ?? .orange
    }
    
    var body: some View {
        ZStack {
            content
                .blur(radius: userViewModel.subscriptionActive ? 0 : 8)
            
            if !userViewModel.subscriptionActive {
                VStack {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 24))
                        .foregroundColor(accentColor)
                        .padding(.bottom)
                    
                    Text("Become Premium Member")
                        .font(.headline)
                        .foregroundColor(accentColor)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.3))
               
                .onTapGesture {
                    showingPaywall = true
                }
            }
        }
        .sheet(isPresented: $showingPaywall) {
            if let offering = userViewModel.offerings?.current {
                PaywallView(offering: offering)
            }
        }
    }
} 
