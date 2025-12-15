import Foundation
import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    private let coordinator: LoginCoordinator
    
    init(coordinator: LoginCoordinator) {
        self.coordinator = coordinator
    }
    
    func loginWithSpotify() {
        print("🎵 Iniciando login com Spotify...")
        isLoading = true
        errorMessage = ""
        
        // Inicia o fluxo OAuth
        SpotifyAuthService.shared.startLogin()
        
        // Observa quando o token for salvo
        observeTokenSaved()
    }
    
    private func observeTokenSaved() {
        Task {
            var attempts = 0
            let maxAttempts = 120 // 60 segundos (120 * 0.5s)
            
            while attempts < maxAttempts {
                try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 segundos
                
                if TokenManager.shared.hasValidToken() {
                    print("✅ Token detectado! Navegando para Home...")
                    isLoading = false
                    coordinator.navigateToHome()
                    return
                }
                
                attempts += 1
            }
            
            // Timeout
            isLoading = false
            errorMessage = "Login expirou. Tente novamente."
            print("⏱️ Timeout no login")
        }
    }
}
