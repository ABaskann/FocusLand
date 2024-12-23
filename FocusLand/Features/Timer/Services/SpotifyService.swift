import Foundation
import UIKit

class SpotifyService: ObservableObject {
    static let shared = SpotifyService()
    
    @Published var isConnected = false
    @Published var playlists: [SpotifyPlaylist] = []
    
    private var accessToken: String?
    
    private init() {}
    
    func authorize() {
        let scope = "playlist-read-private playlist-read-collaborative user-read-playback-state user-modify-playback-state"
        let redirectURI = SpotifyConfig.redirectURL
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "accounts.spotify.com"
        components.path = "/authorize"
        components.queryItems = [
            URLQueryItem(name: "client_id", value: SpotifyConfig.clientID),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "scope", value: scope),
            URLQueryItem(name: "show_dialog", value: "true")  // Force showing the auth dialog
        ]
        
        guard let url = components.url else {
            print("Failed to create Spotify auth URL")
            return
        }
        
        print("Opening URL: \(url.absoluteString)")  // Debug print
        UIApplication.shared.open(url) { success in
            if !success {
                print("Failed to open Spotify auth URL")
            }
        }
    }
    
    func handleCallback(_ url: URL) {
        print("Received callback URL: \(url.absoluteString)")  // Debug print
        
        guard url.absoluteString.starts(with: SpotifyConfig.redirectURL),
              let fragment = url.fragment else {
            print("Invalid callback URL")
            return
        }
        
        let params = fragment.components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce(into: [String: String]()) { dict, pair in
                if pair.count == 2 {
                    dict[pair[0]] = pair[1].removingPercentEncoding ?? pair[1]
                }
            }
        
        if let token = params["access_token"] {
            print("Successfully got access token")  // Debug print
            self.accessToken = token
            DispatchQueue.main.async {
                self.isConnected = true
            }
        } else {
            print("No access token found in callback")
            if let error = params["error"] {
                print("Auth error: \(error)")
            }
        }
    }
    
    func fetchPlaylists() async throws -> [SpotifyPlaylist] {
        guard let accessToken = accessToken else { throw SpotifyError.notAuthenticated }
        
        let url = URL(string: "https://api.spotify.com/v1/me/playlists")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(SpotifyPlaylistResponse.self, from: data)
        playlists = response.items
        return response.items
    }
    
    func playPlaylist(_ uri: String) {
        guard let accessToken = accessToken else { return }
        
        let url = URL(string: "https://api.spotify.com/v1/me/player/play")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let body = ["context_uri": uri]
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Error playing playlist: \(error)")
            }
        }.resume()
    }
}

struct SpotifyPlaylist: Codable, Identifiable {
    let id: String
    let name: String
    let uri: String
    let images: [SpotifyImage]
}

struct SpotifyImage: Codable {
    let url: String
}

struct SpotifyPlaylistResponse: Codable {
    let items: [SpotifyPlaylist]
}

enum SpotifyError: Error {
    case notAuthenticated
} 
