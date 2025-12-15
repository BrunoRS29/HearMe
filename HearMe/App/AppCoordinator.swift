import SwiftUI
import Combine

@MainActor
final class AppCoordinator: ObservableObject {
    @Published var isLoggedIn = false
    
    init() {
        // Verificar se tem token ao iniciar
        checkAuthStatus()
    }
    
    func checkAuthStatus() {
        isLoggedIn = TokenManager.shared.hasValidToken()
        print("🔐 Status de autenticação: \(isLoggedIn ? "Logado" : "Deslogado")")
    }
    
    func showHome() {
        isLoggedIn = true
    }
    
    func logout() {
        TokenManager.shared.clearToken()
        isLoggedIn = false
        print("👋 Logout realizado")
    }
}
