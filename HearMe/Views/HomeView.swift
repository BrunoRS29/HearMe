import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        NavigationStack {
            List(viewModel.recentTracks) { track in
                Button {
                    print("🎧 Cliquei em \(track.trackName)")
                    // aqui você pode chamar algo do ViewModel, ex: viewModel.openDetails(for: track)
                } label: {
                    HStack(spacing: 12) {
                        // Capa do álbum
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
                        
                        // Informações da música
                        VStack(alignment: .leading, spacing: 4) {
                            Text(track.trackName)
                                .font(.headline)
                            Text(track.artistName)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text(track.albumName)
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white) // fundo clicável
                    .cornerRadius(8)
                }
                .buttonStyle(.plain)
                .listRowSeparator(.hidden) // opcional: esconde divisor padrão da List
            }
            .navigationTitle("Músicas do dia")
            .task {
                await viewModel.load()
            }
        }
    }
}
