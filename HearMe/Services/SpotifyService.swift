import Foundation

final class SpotifyService {
    func fetchRecentlyPlayedToday() async throws -> [Music] {
        guard let token = TokenManager.shared.getToken() else {
            throw SpotifyError.noToken
        }
        
        // Cálculo do início do dia (00h00 local → convertido para UTC)
        let startOfDayLocal = Calendar.current.startOfDay(for: Date())
        let startOfDayUTC = startOfDayLocal.toUTC()
        
        // Chama a função recursiva inicial (sem "before")
        let allTracks = try await fetchPage(
            token: token,
            before: nil,
            startOfDayUTC: startOfDayUTC
        )
        
        return allTracks
    }
    
    // Função recursiva
    private func fetchPage(
        token: String,
        before: Int?,
        startOfDayUTC: Date
    ) async throws -> [Music] {
        let limit = 50
        var urlString = "https://api.spotify.com/v1/me/player/recently-played?limit=\(limit)"
        if let before = before {
            urlString += "&before=\(before)"
        }
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw SpotifyError.invalidResponse
        }
    
        switch httpResponse.statusCode {
        case 200: break
        case 401: throw SpotifyError.unauthorized
        default: throw SpotifyError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let result = try decoder.decode(SpotifyRecentResponse.self, from: data)
        
        // Filtrar apenas as músicas de hoje
        let todaysItems = result.items.filter { $0.played_at >= startOfDayUTC }
        
        // Se o último item ainda é de hoje, busca a próxima página recursivamente
        if let lastPlayed = result.items.last?.played_at, lastPlayed >= startOfDayUTC {
            let nextBefore = Int(lastPlayed.timeIntervalSince1970 * 1000)
            let nextPage = try await fetchPage(
                token: token,
                before: nextBefore,
                startOfDayUTC: startOfDayUTC
            )
            return todaysItems.map { $0.toMusic() } + nextPage
        } else {
            // Chegamos antes da meia-noite → fim da recursão
            return todaysItems.map { $0.toMusic() }
        }
    }
}

// MARK: - Extensões auxiliares
extension Date {
    func toUTC() -> Date {
        let offset = TimeInterval(TimeZone.current.secondsFromGMT(for: self))
        return addingTimeInterval(-offset)
    }
}

// MARK: - Modelos Spotify
struct SpotifyRecentResponse: Codable {
    let items: [SpotifyPlayedItem]
}

struct SpotifyPlayedItem: Codable {
    let track: SpotifyTrackItem
    let played_at: Date
    
    func toMusic() -> Music {
        Music(
            trackName: track.name,
            artistName: track.artists.first?.name ?? "",
            albumName: track.album.name,
            albumArtURL: track.album.images.first?.url,
            playedAt: played_at,
            spotifyURL: track.external_urls["spotify"]
        )
    }
}

struct SpotifyTrackItem: Codable {
    let name: String
    let album: SpotifyAlbum
    let artists: [SpotifyArtist]
    let external_urls: [String:String]
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

// MARK: - Erros personalizados do Spotify
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
