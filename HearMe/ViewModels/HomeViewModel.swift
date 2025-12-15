import Foundation
import SwiftUI
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var recentTracks: [SpotifyTrack] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private let spotifyService = SpotifyService()
    private let coordinator: HomeCoordinator

    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }

    func load() async {
        // Debug: verificar token
        guard let token = TokenManager.shared.getToken() else {
            print("❌ Nenhum token encontrado!")
            errorMessage = "Token não encontrado. Faça login novamente."
            coordinator.logout()
            return
        }
        
        print("📱 Token encontrado: \(token.prefix(30))...")
        
        isLoading = true
        errorMessage = nil
        
        do {
            recentTracks = try await spotifyService.fetchRecentlyPlayed()
            print("✅ \(recentTracks.count) músicas carregadas")
        } catch SpotifyError.unauthorized {
            print("❌ Token expirado")
            errorMessage = "Token expirado. Faça login novamente."
            TokenManager.shared.clearToken()
            coordinator.logout()
        } catch {
            print("❌ Erro ao carregar: \(error)")
            errorMessage = "Erro ao carregar músicas: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func logout() {
        coordinator.logout()
    }
}
