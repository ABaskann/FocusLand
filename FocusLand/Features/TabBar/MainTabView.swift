import SwiftUI
import _SwiftData_SwiftUI

struct MainTabView: View {
    @Query private var settings: [TimerSettings]
    @State private var selectedTab = 0
    
    private var accentColor: Color {
        Color(hex: settings.first?.selectedColor ?? "#FF9500") ?? .orange
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            PomodoroTimerView()
                .tabItem {
                    Image(systemName: "timer")
                    Text("Timer")
                }
                .tag(1)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(2)
        }
        .tint(accentColor) // This will update the tab bar color
    }
} 
