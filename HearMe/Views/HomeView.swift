import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var selectedTab = 1 // aba padrão (histórico)

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 🧱 LISTA de músicas
                List(viewModel.recentTracks) { track in
                    Button {
                        viewModel.didTapGoToSoftd(for: track)
                    } label: {
                        HStack(spacing: 12) {
                            // capa do álbum
                            if let urlString = track.albumArtURL,
                               let url = URL(string: urlString) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    Color.gray.opacity(0.3)
                                }
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)
                                .clipped()
                            } else {
                                Color.gray.opacity(0.3)
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(8)
                            }

                            // infos da música
                            VStack(alignment: .leading, spacing: 4) {
                                Text(track.trackName)
                                    .font(.headline)
                                Text(track.artistName)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Text(track.albumName)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()
                        }
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .buttonStyle(.plain)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color("BackgroundColor"))
                }
                .scrollContentBackground(.hidden)
                .background(Color("BackgroundColor"))
                .navigationTitle("Histórico de músicas do dia")
                .toolbarTitleDisplayMode(.large)

                // 🔄 PUXAR PARA ATUALIZAR
                .refreshable {
                    await viewModel.load() // recarrega os dados
                }

                // 🧭 BOTTOM NAVBAR
                BottomNavigationBar(
                    selectedIndex: selectedTab,
                    onItemSelected: { index in
                        selectedTab = index
                        print("🟦 Aba selecionada: \(index)")
                    }
                )
            }
        }
        .task {
            await viewModel.load() // chamada inicial
        }
        .onAppear {
            UINavigationBar.appearance().largeTitleTextAttributes = [
                .font: UIFont.systemFont(ofSize: 24, weight: .bold)
            ]
        }
    }
}

// MARK: - Preview
extension HomeViewModel {
    static var preview: HomeViewModel {
        let appCoordinator = AppCoordinator()
        let homeCoordinator = HomeCoordinator(appCoordinator: appCoordinator)
        let vm = HomeViewModel(coordinator: homeCoordinator)

        vm.recentTracks = [
            Music(
                trackName: "Bohemian Rhapsody",
                artistName: "Queen",
                albumName: "A Night at the Opera",
                albumArtURL: "https://lastfm.freetls.fastly.net/i/u/300x300/2a96cbd8b46e442fc41c2b86b821562f.png",
                playedAt: Date().addingTimeInterval(-3600)
            ),
            Music(
                trackName: "Stairway to Heaven",
                artistName: "Led Zeppelin",
                albumName: "Led Zeppelin IV",
                albumArtURL: "https://lastfm.freetls.fastly.net/i/u/300x300/f8c5e5f5a5a5a5a5a5a5a5a5a5a5a5a5.png",
                playedAt: Date().addingTimeInterval(-3600)
            ),
            Music(
                trackName: "Hotel California",
                artistName: "Eagles",
                albumName: "Hotel California",
                albumArtURL: nil,
                playedAt: Date().addingTimeInterval(-3600)
            ),
            Music(
                trackName: "Imagine",
                artistName: "John Lennon",
                albumName: "Imagine",
                albumArtURL: nil,
                playedAt: Date().addingTimeInterval(-3600)
            )
        ]

        return vm
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel.preview)
}
