import Foundation
import UIKit

class SpotifyService: ObservableObject {
    static let shared = SpotifyService()
    
    @Published var isConnected = false
    @Published var playlists: [SpotifyPlaylist] = []
    @Published var errorMessage: String?
    @Published var isPlayerReady = false
    @Published var currentTrack: String?
    @Published var isPlaying = false
    @Published var activeDevice: SpotifyDevice?
    
    private var accessToken: String? {
        didSet {
            // Save token when it changes
            if let token = accessToken {
                UserDefaults.standard.set(token, forKey: "SpotifyAccessToken")
            }
        }
    }
    
    private init() {
        // Load saved token on init
        if let savedToken = UserDefaults.standard.string(forKey: "SpotifyAccessToken") {
            self.accessToken = savedToken
            self.isConnected = true
            self.isPlayerReady = true
        }
    }
    
    // Add model for device
    struct SpotifyDevice: Codable, Identifiable {
        let id: String
        let name: String
        let type: String
        let isActive: Bool
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case type
            case isActive = "is_active"
        }
    }
    
    struct DevicesResponse: Codable {
        let devices: [SpotifyDevice]
    }
    
    // Add method to fetch devices
    func fetchDevices() async throws -> [SpotifyDevice] {
        guard let accessToken = accessToken else {
            throw SpotifyError.notAuthenticated
        }
        
        let url = URL(string: "https://api.spotify.com/v1/me/player/devices")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw SpotifyError.apiError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 0)
        }
        
        let devicesResponse = try JSONDecoder().decode(DevicesResponse.self, from: data)
        if let activeDevice = devicesResponse.devices.first(where: { $0.isActive }) {
            DispatchQueue.main.async {
                self.activeDevice = activeDevice
            }
        }
        return devicesResponse.devices
    }
    
    // Update playPlaylist method
    func playPlaylist(_ uri: String) async {
        guard let accessToken = accessToken else {
            errorMessage = "Not authenticated"
            return
        }
        
        do {
            // First fetch devices
            let devices = try await fetchDevices()
            
            guard !devices.isEmpty else {
                errorMessage = "No Spotify devices found. Please open Spotify on any device."
                return
            }
            
            // Get active device or use the first available one
            let deviceId = devices.first(where: { $0.isActive })?.id ?? devices[0].id
            
            // Construct URL with device_id
            let url = URL(string: "https://api.spotify.com/v1/me/player/play?device_id=\(deviceId)")!
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body = ["context_uri": uri]
            request.httpBody = try? JSONEncoder().encode(body)
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 204 {
                    DispatchQueue.main.async {
                        self.isPlaying = true
                        self.isPlayerReady = true
                    }
                } else {
                    errorMessage = "Failed to play playlist (Status: \(httpResponse.statusCode)). Make sure Spotify is open on your device."
                }
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func authorize() {
        let scope = "streaming playlist-read-private playlist-read-collaborative user-read-playback-state user-modify-playback-state"
        
        // Use a simpler encoding approach for the redirect URI
        let redirectURI = "focusland://callback"
        
        // Build the authorization URL manually to ensure proper encoding
        let baseURL = "https://accounts.spotify.com/authorize"
        let encodedScope = scope.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? scope
        let encodedRedirect = redirectURI.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? redirectURI
        
        let urlString = "\(baseURL)?" +
            "client_id=\(SpotifyConfig.clientID)" +
            "&response_type=token" +
            "&redirect_uri=\(encodedRedirect)" +
            "&scope=\(encodedScope)" +
            "&show_dialog=true"
        
        guard let url = URL(string: urlString) else {
            print("Failed to create Spotify auth URL")
            return
        }
        
        print("Authorization URL: \(url.absoluteString)")
        print("Redirect URI: \(redirectURI)")
        print("Client ID: \(SpotifyConfig.clientID)")
        
        DispatchQueue.main.async {
            UIApplication.shared.open(url) { success in
                if success {
                    print("Successfully opened Safari")
                } else {
                    print("Failed to open URL")
                }
            }
        }
    }
    
    func handleCallback(_ url: URL) {
        print("Full callback URL: \(url.absoluteString)")
        print("URL scheme: \(url.scheme ?? "nil")")
        print("URL host: \(url.host ?? "nil")")
        print("URL path: \(url.path)")
        print("URL fragment: \(url.fragment ?? "nil")")
        
        guard let scheme = url.scheme, scheme.lowercased() == "focusland" else {
            print("Invalid URL scheme: \(url.scheme ?? "nil")")
            return
        }
        
        var token: String?
        
        if let fragment = url.fragment {
            let params = fragment.components(separatedBy: "&")
                .map { $0.components(separatedBy: "=") }
                .reduce(into: [String: String]()) { dict, pair in
                    if pair.count == 2 {
                        dict[pair[0]] = pair[1].removingPercentEncoding ?? pair[1]
                    }
                }
            token = params["access_token"]
        }
        
        if token == nil, let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems {
            token = queryItems.first(where: { $0.name == "access_token" })?.value
        }
        
        if let token = token {
            print("Successfully got access token: \(token.prefix(5))...")
            self.accessToken = token
            DispatchQueue.main.async {
                self.isConnected = true
                self.isPlayerReady = true
            }
        } else {
            print("No access token found in callback")
            if let errorParam = url.queryItems?.first(where: { $0.name == "error" })?.value {
                print("Auth error: \(errorParam)")
            }
        }
    }
    
    func fetchPlaylists() async throws -> [SpotifyPlaylist] {
        guard let accessToken = accessToken else { 
            print("No access token available")
            throw SpotifyError.notAuthenticated 
        }
        
        let url = URL(string: "https://api.spotify.com/v1/me/playlists")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw SpotifyError.invalidResponse
        }
        
        if httpResponse.statusCode != 200 {
            throw SpotifyError.apiError(statusCode: httpResponse.statusCode)
        }
        
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(SpotifyPlaylistResponse.self, from: data)
            DispatchQueue.main.async {
                self.playlists = response.items
            }
            return response.items
        } catch {
            throw SpotifyError.decodingError(error)
        }
    }
    
    func togglePlayback() async {
        guard let accessToken = accessToken else { return }
        
        let endpoint = isPlaying ? "pause" : "play"
        let url = URL(string: "https://api.spotify.com/v1/me/player/\(endpoint)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if (response as? HTTPURLResponse)?.statusCode == 204 {
                DispatchQueue.main.async {
                    self.isPlaying.toggle()
                }
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

// Models
struct SpotifyPlaylist: Codable, Identifiable {
    let id: String
    let name: String
    let uri: String
    let images: [SpotifyImage]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, uri, images
    }
}

struct SpotifyImage: Codable {
    let url: String
    let height: Int?
    let width: Int?
    
    enum CodingKeys: String, CodingKey {
        case url, height, width
    }
}

struct SpotifyPlaylistResponse: Codable {
    let items: [SpotifyPlaylist]
}

enum SpotifyError: Error {
    case notAuthenticated
    case invalidResponse
    case apiError(statusCode: Int)
    case decodingError(Error)
    
    var localizedDescription: String {
        switch self {
        case .notAuthenticated:
            return "Not authenticated with Spotify"
        case .invalidResponse:
            return "Invalid response from Spotify"
        case .apiError(let statusCode):
            return "Spotify API error (Status \(statusCode))"
        case .decodingError(let error):
            return "Failed to decode Spotify data: \(error.localizedDescription)"
        }
    }
}

extension URL {
    var queryItems: [URLQueryItem]? {
        URLComponents(url: self, resolvingAgainstBaseURL: false)?.queryItems
    }
} 
