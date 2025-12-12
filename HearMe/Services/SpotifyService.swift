protocol SpotifyServiceProtocol {
    func fetchRecentlyPlayed() async throws -> [Music]
}

final class MockSpotifyService: SpotifyServiceProtocol {
    func fetchRecentlyPlayed() async throws -> [Music] {
        return [
            Music(trackName: "Song One", artistName: "Artist A", albumArtURL: nil),
            Music(trackName: "Song Two", artistName: "Artist B", albumArtURL: nil)
        ]
    }
}
