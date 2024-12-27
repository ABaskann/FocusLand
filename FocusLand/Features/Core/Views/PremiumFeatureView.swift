import SwiftUI
import RevenueCat
import RevenueCatUI

struct PremiumFeatureView<Content: View>: View {
    @ObservedObject private var userViewModel = UserViewModel.shared
    @State private var showingPaywall = false
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            content
                .blur(radius: userViewModel.subscriptionActive ? 0 : 8)
            
            if !userViewModel.subscriptionActive {
                VStack {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                    
                    Text("Premium Feature")
                        .font(.headline)
                        .foregroundColor(.gray)
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