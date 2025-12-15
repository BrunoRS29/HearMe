import Foundation
import AuthenticationServices
import UIKit

final class SpotifyAuthService: NSObject {
    static let shared = SpotifyAuthService()
    
    private let clientID = "8b5011ffb15d4f65acf9926f6dc3bf64"
    private let clientSecret = "77fca5ed90584b0b83c658acbe38e133"  // ← ADICIONE AQUI
    private let redirectURI = "diarymusic://callback"
    private let scopes = "user-read-recently-played"
    
    private var currentSession: ASWebAuthenticationSession?
    
    func startLogin() {
        print("🎵 Iniciando autenticação Spotify...")
        
        guard let authURL = makeAuthURL() else {
            print("❌ Erro ao criar Auth URL")
            return
        }
        
        print("🔗 Auth URL: \(authURL.absoluteString)")
        
        currentSession = ASWebAuthenticationSession(
            url: authURL,
            callbackURLScheme: "diarymusic",
            completionHandler: { [weak self] callbackURL, error in
                if let error = error {
                    print("❌ Erro no callback: \(error.localizedDescription)")
                    return
                }
                
                guard let callbackURL = callbackURL else {
                    print("❌ Callback URL é nil")
                    return
                }
                
                print("✅ Callback recebido: \(callbackURL.absoluteString)")
                
                // Extrair o código de autorização
                if let code = self?.extractCode(from: callbackURL) {
                    print("✅ Código de autorização: \(code.prefix(20))...")
                    Task {
                        await self?.exchangeCodeForToken(code: code)
                    }
                } else {
                    print("❌ Código não encontrado no callback")
                }
                
                self?.currentSession = nil
            })
        
        currentSession?.presentationContextProvider = self
        currentSession?.prefersEphemeralWebBrowserSession = true
        currentSession?.start()
        
        print("🚀 Sessão de autenticação iniciada")
    }
    
    private func makeAuthURL() -> URL? {
        var components = URLComponents(string: "https://accounts.spotify.com/authorize")
        components?.queryItems = [
            .init(name: "client_id", value: clientID),
            .init(name: "response_type", value: "code"),  // ← MUDOU: code em vez de token
            .init(name: "redirect_uri", value: redirectURI),
            .init(name: "scope", value: scopes),
            .init(name: "show_dialog", value: "true")
        ]
        return components?.url
    }
    
    private func extractCode(from url: URL) -> String? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return nil
        }
        
        return queryItems.first(where: { $0.name == "code" })?.value
    }
    
    private func exchangeCodeForToken(code: String) async {
        print("🔄 Trocando código por token...")
        
        guard let url = URL(string: "https://accounts.spotify.com/api/token") else {
            print("❌ URL inválida")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // Criar Basic Auth
        let credentials = "\(clientID):\(clientSecret)"
        let credentialsData = credentials.data(using: .utf8)!
        let base64Credentials = credentialsData.base64EncodedString()
        request.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
        
        // Body
        let bodyParams = [
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": redirectURI
        ]
        
        let bodyString = bodyParams
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
        
        request.httpBody = bodyString.data(using: .utf8)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Resposta inválida")
                return
            }
            
            print("📡 Status Code: \(httpResponse.statusCode)")
            
            if httpResponse.statusCode == 200 {
                let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
                TokenManager.shared.saveToken(tokenResponse.access_token)
                print("✅ Token salvo: \(tokenResponse.access_token.prefix(30))...")
            } else {
                let errorString = String(data: data, encoding: .utf8) ?? "unknown"
                print("❌ Erro do servidor: \(errorString)")
            }
        } catch {
            print("❌ Erro na requisição: \(error)")
        }
    }
}

// MARK: - Token Response Model
struct TokenResponse: Codable {
    let access_token: String
    let token_type: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
}

// MARK: - ASWebAuthenticationPresentationContextProviding
extension SpotifyAuthService: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive })
        else {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                return scene.windows.first ?? UIWindow(windowScene: scene)
            }
            fatalError("Nenhuma windowScene disponível")
        }
        
        return windowScene.windows.first { $0.isKeyWindow }
            ?? windowScene.windows.first
            ?? UIWindow(windowScene: windowScene)
    }
}
