import SwiftUI
import _SwiftData_SwiftUI

struct MainTabView: View {
    @Query private var settings: [TimerSettings]
    @Environment(TimerManager.self) private var timerManager
    @State private var selectedTab = 0
    @State private var attemptedTab: Int?
    @State private var showingAlert = false
    
    private var accentColor: Color {
        Color(hex: settings.first?.selectedColor ?? "#FF9500") ?? .orange
    }
    
    var body: some View {
        TabView(selection: Binding(
            get: { selectedTab },
            set: { newTab in
                if timerManager.isActive {
                    attemptedTab = newTab
                    showingAlert = true
                } else {
                    selectedTab = newTab
                }
            }
        )) {
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
        .tint(accentColor)
        .alert("Timer Running", isPresented: $showingAlert) {
            Button("Stay", role: .cancel) {
                // Do nothing, stay on current tab
            }
            
            Button("Reset Timer", role: .destructive) {
                timerManager.isActive = false
                timerManager.resetTimer(settings: settings.first)
                if let newTab = attemptedTab {
                    selectedTab = newTab
                }
            }
        } message: {
            Text("Changing tabs will reset your current focus session. Do you want to continue?")
        }
    }
} 
