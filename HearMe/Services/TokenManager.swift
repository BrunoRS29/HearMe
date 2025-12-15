import Foundation

final class TokenManager {
    static let shared = TokenManager()
    
    private let tokenKey = "spotify_access_token"
    private let expirationKey = "spotify_token_expiration"
    
    private init() {}
    
    /// Salva o token com tempo de expiração (1 hora padrão)
    func saveToken(_ token: String, expiresIn: TimeInterval = 3600) {
        UserDefaults.standard.set(token, forKey: tokenKey)
        
        let expirationDate = Date().addingTimeInterval(expiresIn)
        UserDefaults.standard.set(expirationDate, forKey: expirationKey)
        
        print("💾 Token salvo (expira em \(Int(expiresIn/60)) minutos)")
    }
    
    /// Recupera o token se ainda for válido
    func getToken() -> String? {
        guard let token = UserDefaults.standard.string(forKey: tokenKey),
              !isTokenExpired() else {
            print("⚠️ Token expirado ou não encontrado")
            clearToken()
            return nil
        }
        return token
    }
    
    /// Remove o token
    func clearToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
        UserDefaults.standard.removeObject(forKey: expirationKey)
        print("🗑️ Token removido")
    }
    
    /// Verifica se existe um token válido
    func hasValidToken() -> Bool {
        let hasToken = getToken() != nil
        print("🔍 Token válido: \(hasToken ? "Sim" : "Não")")
        return hasToken
    }
    
    /// Verifica se o token expirou
    private func isTokenExpired() -> Bool {
        guard let expirationDate = UserDefaults.standard.object(forKey: expirationKey) as? Date else {
            return true
        }
        return Date() > expirationDate
    }
    
    /// Tempo restante até expiração (em segundos)
    func timeUntilExpiration() -> TimeInterval? {
        guard let expirationDate = UserDefaults.standard.object(forKey: expirationKey) as? Date else {
            return nil
        }
        return expirationDate.timeIntervalSinceNow
    }
}
