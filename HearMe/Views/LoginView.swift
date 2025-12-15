import SwiftUI

struct LoginView: View {
    @StateObject var viewModel: LoginViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Logo/Título
            VStack(spacing: 10) {
                Image(systemName: "music.note.list")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                
                Text("DiaryMusic")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Suas músicas recentes do Spotify")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            // Mensagem de erro
            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            // Botão de Login
            Button(action: viewModel.loginWithSpotify) {
                HStack(spacing: 12) {
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Image(systemName: "music.note")
                        Text("Entrar com Spotify")
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(viewModel.isLoading)
            .padding(.horizontal, 40)
            
            Text("Você será redirecionado para fazer login no Spotify")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel(
        coordinator: LoginCoordinator(
            appCoordinator: AppCoordinator()
        )
    ))
}
