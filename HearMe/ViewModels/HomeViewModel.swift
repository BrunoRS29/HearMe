import Combine

final class HomeViewModel: ObservableObject {
    @Published var recentTracks: [Music] = []
    private let spotifyService: SpotifyServiceProtocol

    init(spotifyService: SpotifyServiceProtocol = MockSpotifyService()) {
        self.spotifyService = spotifyService
    }

    @MainActor
    func load() async {
        do {
            recentTracks = try await spotifyService.fetchRecentlyPlayed()
        } catch {
            print(error)
        }
    }
}
