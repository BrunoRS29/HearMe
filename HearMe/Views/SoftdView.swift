import SwiftUI

struct SoftdView: View {
    @StateObject var viewModel: SoftdViewModel
    @State private var selectedTab = 1

    var body: some View {
        VStack {
            // Barra superior
            HStack {
                Button {
                    viewModel.goBack()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(Color("MainColor"))
                }

                Spacer()

                Text("Música do dia")
                    .font(.title.bold())

                Spacer()

                Button {
                    print("Ainda n tem 🤯")
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title2)
                        .foregroundColor(Color("MainColor"))
                }
            }
            .padding(.horizontal)

            // Separador
            Rectangle()
                .fill(Color.gray.opacity(0.4))
                .frame(height: 1)
                .padding(.horizontal)

            // Conteúdo principal
            VStack(spacing: 20) {
                if let urlString = viewModel.track.albumArtURL,
                   let url = URL(string: urlString) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .mask(
                                LinearGradient(
                                    gradient: Gradient(colors: [.white, .white, .clear]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                    .frame(width: 320, height: 320)
                    .cornerRadius(8)
                    .clipped()
                }

                Text(viewModel.track.trackName)
                    .font(.title)
                    .bold()

                Text(viewModel.track.artistName)
                    .font(.title2)
                    .foregroundStyle(.secondary)

                Button {
                    viewModel.setSoftd()
                } label: {
                    HStack {
                        Text("Definir como música do dia")
                    }
                    .font(.title3.bold())
                    .padding(.horizontal, 30)
                    .padding(.vertical, 14)
                    .background(Color("MainColor"))
                    .foregroundColor(.black)
                    .cornerRadius(12)
                    .shadow(color: Color("MainColor").opacity(0.4), radius: 8, y: 4)
                }
                .padding(.top, 20)
                .alert(
                    "Já existe uma música do dia!",
                    isPresented: $viewModel.showReplaceAlert
                ) {
                    Button("Cancelar", role: .cancel) {}
                    Button("Trocar") {
                        viewModel.confirmReplaceSongOfTheDay()
                    }
                } message: {
                    if let currentName = viewModel.currentSongOfTheDayName {
                        Text("A atual é **\(currentName)**. Deseja substituí-la por **\(viewModel.track.trackName)**?")
                    }
                }

                // 🔹 A partir daqui é fora do botão/alert
                Spacer()

                Button {
                    viewModel.openOnSpotify()
                } label: {
                    Label("Ouvir no Spotify", systemImage: "play.circle.fill")
                        .font(.headline)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 14)
                        .background(Color.black) // fundo preto
                        .foregroundColor(Color("MainColor")) // texto e ícone verdes
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.green, lineWidth: 2) // borda verde
                        )
                        .cornerRadius(12)
                        .shadow(color: Color("MainColor").opacity(0.4), radius: 8, y: 4) // sombra verde
                }
                .padding(.bottom, 16)

                HStack {
                    // por enquanto vazio
                }

                BottomNavigationBar(
                    selectedIndex: selectedTab,
                    onItemSelected: { index in
                        selectedTab = index
                        print("🟦 Aba selecionada: \(index)")
                    }
                )
            }
            .padding(.top, 20)
        }
        .navigationTitle("Detalhes")
        .background(Color("BackgroundColor"))
    }
}

// MARK: - Preview
extension Music {
    static var previewTrack: Music {
        Music(
            trackName: "Imagine",
            artistName: "John Lennon",
            albumName: "Imagine",
            albumArtURL: "https://lastfm.freetls.fastly.net/i/u/300x300/2a96cbd8b46e442fc41c2b86b821562f.png",
            playedAt: Date(),
            isSongOfTheDay: false
        )
    }
}

#Preview {
    SoftdView(viewModel: .preview)
}
