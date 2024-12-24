import SwiftUI

struct SpotifyPlayerView: View {
    @ObservedObject var spotifyService: SpotifyService
    @State private var isPlaying = false
    
    var body: some View {
        VStack(spacing: 8) {
            // Player controls
            HStack(spacing: 20) {
                Button(action: {
                    // Previous track
                }) {
                    Image(systemName: "backward.fill")
                        .font(.title2)
                }
                
                Button(action: {
                    isPlaying.toggle()
                    // Toggle play/pause
                }) {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 44))
                }
                
                Button(action: {
                    // Next track
                }) {
                    Image(systemName: "forward.fill")
                        .font(.title2)
                }
            }
            .foregroundColor(.white)
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.white.opacity(0.2))
                        .frame(height: 4)
                    
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: geometry.size.width * 0.3, height: 4)
                }
            }
            .frame(height: 4)
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(15)
    }
} 