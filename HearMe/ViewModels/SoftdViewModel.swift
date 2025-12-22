import Foundation
import Combine
import UIKit

@MainActor
final class SoftdViewModel: ObservableObject {
    let coordinator: SoftdCoordinator
    var track: Music
    
    @Published var showReplaceAlert = false
    @Published var currentSongOfTheDayName: String?

    init(coordinator: SoftdCoordinator, track: Music) {
        self.coordinator = coordinator
        self.track = track
    }
    
    func goBack() {
        coordinator.goBackToHome()
    }
    
    func setSoftd() {
        coordinator.setSoftd(track)
    }
    
    func confirmReplaceSongOfTheDay() {
        coordinator.confirmReplaceSongOfTheDay(track)
    }
    
    func openOnSpotify() {
        // se veio um link exato da API, usa ele
        if let urlString = track.spotifyURL,        // adicione a prop spotifyURL em Music
           let url = URL(string: urlString) {
            UIApplication.shared.open(url)
            return
        }

        // senão, faz busca pelo nome
        let query = track.trackName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "https://open.spotify.com/search/\(query)") {
            UIApplication.shared.open(url)
        }
    }
}


// MARK: - Preview helper
extension SoftdViewModel {
    static var preview: SoftdViewModel {
        let appCoordinator = AppCoordinator()
        let dummyTrack = Music(
            trackName: "Imagine",
            artistName: "John Lennon",
            albumName: "Imagine",
            albumArtURL: "https://lastfm.freetls.fastly.net/i/u/300x300/2a96cbd8b46e442fc41c2b86b821562f.png",
            playedAt: Date(),
            isSongOfTheDay: false
        )
        let softdCoordinator = SoftdCoordinator(appCoordinator: appCoordinator,
                                                track: dummyTrack)
        return SoftdViewModel(coordinator: softdCoordinator,
                              track: dummyTrack)
    }
}
