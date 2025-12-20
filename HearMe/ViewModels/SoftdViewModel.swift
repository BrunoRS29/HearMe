import Foundation
import Combine

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
