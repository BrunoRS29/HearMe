import Foundation

enum SpotifyError: Error, LocalizedError {
    case noToken
    case unauthorized
    case invalidResponse
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .noToken:
            return "Token de autenticação não encontrado"
        case .unauthorized:
            return "Token expirado ou inválido"
        case .invalidResponse:
            return "Resposta inválida do servidor"
        case .networkError(let error):
            return "Erro de rede: \(error.localizedDescription)"
        }
    }
}

struct SpotifyTrack: Identifiable {
    let id = UUID()
    let name: String
    let artist: String
}

final class SpotifyService {
    func fetchRecentlyPlayed() async throws -> [SpotifyTrack] {
        guard let token = TokenManager.shared.getToken() else {
            throw URLError(.userAuthenticationRequired)
        }
        
        var request = URLRequest(
            url: URL(string: "https://api.spotify.com/v1/me/player/recently-played?limit=30")!
        )
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        // Interpretar JSON
        let result = try JSONDecoder().decode(SpotifyRecentResponse.self, from: data)
        return result.items.map {
            SpotifyTrack(name: $0.track.name,
                         artist: $0.track.artists.first?.name ?? "")
        }
    }
}

// MARK: - Modelos para decodificar JSON
struct SpotifyRecentResponse: Codable {
    let items: [SpotifyPlayedItem]
}

struct SpotifyPlayedItem: Codable {
    let track: SpotifyTrackItem
}

struct SpotifyTrackItem: Codable {
    let name: String
    let artists: [SpotifyArtist]
}

struct SpotifyArtist: Codable {
    let name: String
}
