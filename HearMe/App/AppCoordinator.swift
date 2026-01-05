import SwiftUI
import Combine

@MainActor
final class AppCoordinator: ObservableObject {
    @Published var isLoggedIn = false
    @Published var currentView: AnyView? = nil
    @Published var navigationPath: [AnyView] = []
    @Published var songOfTheDay: Music?
    
    init() {
        checkAuthStatus()
    }
    
    func checkAuthStatus() {
        isLoggedIn = TokenManager.shared.hasValidToken()
        print("🔐 Status de autenticação: \(isLoggedIn ? "Logado" : "Deslogado")")
    }
    
    func showHome() {
        print("⬅️ AppCoordinator.showHome chamado – retornando à Home")
        currentView = nil   // remove a tela atual
        isLoggedIn = true    // garante que o app continua logado
    }
    
    func logout() {
        TokenManager.shared.clearToken()
        isLoggedIn = false
        print("👋 Logout realizado")
    }
    
    // Agora recebe um `Music`
    func showSoftd(with track: Music) {
        print("➡️ AppCoordinator.showSoftd chamado para \(track.trackName)")
        let coordinator = SoftdCoordinator(appCoordinator: self, track: track)
        currentView = AnyView(coordinator.start())
        print("📱 currentView atribuído")
    }
    
    func showLogin() {
        let loginCoordinator = LoginCoordinator(appCoordinator: self)
        let loginView = loginCoordinator.start()
        navigationPath = [AnyView(loginView)]
    }
    
    func showProfile() {
        print("➡️ AppCoordinator.showProfile chamado")
        let coordinator = ProfileCoordinator(appCoordinator: self)
        currentView = AnyView(coordinator.start())
        print("📱 currentView atribuído com ProfileView")
    }
    
    func showCalendar() {
       let coordiantor = CalendarCoordinator(appCoordinator: self)
        currentView = AnyView(coordiantor.start())
        print("📱 currentView atribuído com CalendarView")
    }
    
}
