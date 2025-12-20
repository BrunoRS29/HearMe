final class SoftdCoordinator: Coordinator {
    typealias Body = SoftdView
    private let appCoordinator: AppCoordinator
    private let track: Music

    init(appCoordinator: AppCoordinator, track: Music) {
        self.appCoordinator = appCoordinator
        self.track = track
    }

    func start() -> SoftdView {
        let viewModel = SoftdViewModel(coordinator: self, track: track)
        return SoftdView(viewModel: viewModel)
    }
    
    func goBackToHome() {
        print("⬅️ Voltando para home")
        appCoordinator.currentView = nil
    }

    func setSoftd(_ newTrack: Music) {
        guard let current = appCoordinator.songOfTheDay else {
            var updated = newTrack
            updated.isSongOfTheDay = true
            appCoordinator.songOfTheDay = updated
            print("🎶 \(updated.trackName) marcada como Música do Dia")
            appCoordinator.currentView = nil
            return
        }

        // se já há outra música marcada no mesmo dia
        if current.trackName != newTrack.trackName {
            // aciona alerta no viewModel
            if let viewModel = getSoftdViewModel() {
                viewModel.currentSongOfTheDayName = current.trackName
                viewModel.showReplaceAlert = true
            }
        }
    }

        private func showReplaceAlert(old: Music, new: Music) {
            // você pode disparar uma ação de alerta via AppCoordinator
            // Em app real, isso seria uma chamada para mostrar Alert na UI.
            // Aqui apenas simula no console:
            print("""
            ⚠️ Já existe uma música do dia:
               \(old.trackName) – \(old.artistName)
            Deseja substituir por:
               \(new.trackName) – \(new.artistName)?
            """)

            // se o usuário confirmar (simulação)
            var newTrackUpdated = new
            var oldTrackUpdated = old
            oldTrackUpdated.isSongOfTheDay = false
            newTrackUpdated.isSongOfTheDay = true

            appCoordinator.songOfTheDay = newTrackUpdated

            print("✅ \(newTrackUpdated.trackName) substituiu \(oldTrackUpdated.trackName) como Música do Dia")
            appCoordinator.currentView = nil
        }
    
    func confirmReplaceSongOfTheDay(_ newTrack: Music) {
        var newTrackUpdated = newTrack
        newTrackUpdated.isSongOfTheDay = true
        appCoordinator.songOfTheDay?.isSongOfTheDay = false
        appCoordinator.songOfTheDay = newTrackUpdated

        print("✅ \(newTrackUpdated.trackName) substituiu como Música do Dia")
        appCoordinator.currentView = nil
    }

    // helper para acessar viewModel ativo (no preview isso pode ser omitido)
    private func getSoftdViewModel() -> SoftdViewModel? {
        // Essa é uma simplificação — na prática o coordinator já possui o viewModel criado durante o start()
        return nil
    }
    
}
