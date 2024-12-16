import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("User Profile")
                    .font(.title)
                    .padding()
                
                // Add your profile page content here
            }
            .navigationTitle("Profile")
        }
    }
} 