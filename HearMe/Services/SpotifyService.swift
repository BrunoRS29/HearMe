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

final class SpotifyService {
    func fetchRecentlyPlayedToday() async throws -> [Music] {
        // Verifica se há token
        guard let token = TokenManager.shared.getToken() else {
            throw SpotifyError.noToken
        }
        
        var request = URLRequest(
            url: URL(string: "https://api.spotify.com/v1/me/player/recently-played?limit=50")!
        )
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // Requisição assíncrona
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw SpotifyError.invalidResponse
        }
        
        // Diagnóstico do status
        print("🔍 Spotify status code:", httpResponse.statusCode)
        if let rawJSON = String(data: data, encoding: .utf8) {
            print("🔍 Spotify raw response:", rawJSON.prefix(300)) // mostra só início
        }
        
        // Trata diferentes status HTTP
        switch httpResponse.statusCode {
        case 200:
            break // ok
        case 401:
            throw SpotifyError.unauthorized
        default:
            throw SpotifyError.invalidResponse
        }
        
        // Decodificar JSON
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let result = try decoder.decode(SpotifyRecentResponse.self, from: data)
        
        // Calcular o início do dia (00h00 local)
        let startOfDay = Calendar.current.startOfDay(for: Date())
        
        // Filtrar músicas tocadas hoje
        let todaysTracks = result.items
            .filter { $0.played_at >= startOfDay }
            .map {
                Music(
                    trackName: $0.track.name,
                    artistName: $0.track.artists.first?.name ?? "",
                    albumName: $0.track.album.name,
                    albumArtURL: $0.track.album.images.first?.url, // ✅ seguro (opcional)
                    playedAt: $0.played_at
                )
            }
        
        return todaysTracks
    }
}

//
// MARK: - Modelos para decodificar JSON da API Spotify
//
struct SpotifyRecentResponse: Codable {
    let items: [SpotifyPlayedItem]
}

struct SpotifyPlayedItem: Codable {
    let track: SpotifyTrackItem
    let played_at: Date
}

struct SpotifyTrackItem: Codable {
    let name: String
    let album: SpotifyAlbum
    let artists: [SpotifyArtist]
}

struct SpotifyArtist: Codable {
    let name: String
}

struct SpotifyAlbum: Codable {
    let name: String
    let images: [SpotifyImage]
}

struct SpotifyImage: Codable {
    let url: String
}
