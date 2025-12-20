import SwiftUI

@main
struct HearMeApp: App {
    @StateObject private var appCoordinator = AppCoordinator()
    
    init() {
        print("🚀 App iniciado")
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if appCoordinator.isLoggedIn {
                    // 🔹 se currentView tiver algo, mostre‑a
                    if let activeView = appCoordinator.currentView {
                        activeView
                    } else {
                        HomeCoordinator(appCoordinator: appCoordinator)
                            .start()
                    }
                } else {
                    LoginCoordinator(appCoordinator: appCoordinator)
                        .start()
                }
            }
            .onOpenURL { url in
                handleIncomingURL(url)
            }
            .onAppear {
                print("✅ View apareceu - onOpenURL está registrado")
            }
        }
    }
    
    private func handleIncomingURL(_ url: URL) {
        print("📥 handleIncomingURL chamado")
        print("📥 URL completa: \(url)")
        print("📥 Scheme: \(url.scheme ?? "nil")")
        print("📥 Host: \(url.host ?? "nil")")
        print("📥 Path: \(url.path)")
        print("📥 Fragment: \(url.fragment ?? "nil")")
        
        guard url.scheme == "diarymusic" else {
            print("❌ Scheme inválido: \(url.scheme ?? "nil")")
            return
        }
        
        print("✅ Scheme válido: diarymusic")
        
        guard let fragment = url.fragment else {
            print("❌ Fragment não encontrado")
            return
        }
        
        print("✅ Fragment encontrado: \(fragment)")
        
        let params = parseFragment(fragment)
        print("✅ Parâmetros parseados: \(params)")
        
        if let token = params["access_token"] {
            print("✅ Token encontrado nos parâmetros")
            TokenManager.shared.saveToken(token)
            print("✅ Token salvo: \(token.prefix(30))...")
            
            Task { @MainActor in
                appCoordinator.checkAuthStatus()
            }
        } else {
            print("❌ Token não encontrado")
            print("Parâmetros disponíveis: \(params.keys)")
        }
    }
    
    private func parseFragment(_ fragment: String) -> [String: String] {
        fragment
            .split(separator: "&")
            .reduce(into: [String: String]()) { result, pair in
                let parts = pair.split(separator: "=", maxSplits: 1)
                if parts.count == 2 {
                    result[String(parts[0])] = String(parts[1])
                }
            }
    }
}

// MARK: - Content View
struct ContentView: View {
    @ObservedObject var appCoordinator: AppCoordinator
    
    var body: some View {
        Group {
            if appCoordinator.isLoggedIn {
                HomeCoordinator(appCoordinator: appCoordinator)
                    .start()
            } else {
                LoginCoordinator(appCoordinator: appCoordinator)
                    .start()
            }
        }
    }
}
