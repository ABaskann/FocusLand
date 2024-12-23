import SwiftUI

struct MusicControlView: View {
    let accentColor: Color
    @StateObject private var spotifyService = SpotifyService.shared
    @State private var showingPlaylists = false
    
    var body: some View {
        VStack(spacing: 12) {
            Button(action: { 
                if spotifyService.isConnected {
                    showingPlaylists = true
                } else {
                    spotifyService.authorize()
                }
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "music.note")
                        .font(.system(size: 18))
                    Text(spotifyService.isConnected ? "Choose Playlist" : "Connect Spotify")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal, 24)
                .background(accentColor)
                .cornerRadius(25)
            }
        }
        .sheet(isPresented: $showingPlaylists) {
            PlaylistsView(accentColor: accentColor)
        }
    }
}

struct PlaylistsView: View {
    let accentColor: Color
    @Environment(\.dismiss) private var dismiss
    @StateObject private var spotifyService = SpotifyService.shared
    @State private var playlists: [SpotifyPlaylist] = []
    @State private var isLoading = false
    @State private var error: Error?
    
    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView()
                } else if let error = error {
                    Text("Error: \(error.localizedDescription)")
                } else {
                    List(playlists) { playlist in
                        PlaylistRow(playlist: playlist)
                            .onTapGesture {
                                spotifyService.playPlaylist(playlist.uri)
                                dismiss()
                            }
                    }
                }
            }
            .navigationTitle("Spotify Playlists")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(accentColor)
                }
            }
        }
        .task {
            await loadPlaylists()
        }
    }
    
    private func loadPlaylists() async {
        isLoading = true
        do {
            playlists = try await spotifyService.fetchPlaylists()
        } catch {
            self.error = error
        }
        isLoading = false
    }
}

struct PlaylistRow: View {
    let playlist: SpotifyPlaylist
    
    var body: some View {
        HStack(spacing: 12) {
            if let imageURL = playlist.images.first?.url {
                AsyncImage(url: URL(string: imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray
                }
                .frame(width: 50, height: 50)
                .cornerRadius(4)
            }
            
            Text(playlist.name)
                .font(.headline)
        }
        .padding(.vertical, 4)
    }
} 