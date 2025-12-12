import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        NavigationStack {
            List(viewModel.recentTracks) { track in
                VStack(alignment: .leading, spacing: 4) {
                    Text(track.trackName)
                        .font(.headline)
                    Text(track.artistName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Músicas Recentes")
            .task {
                await viewModel.load()
            }
        }
    }
}

#Preview {
    // Preview com dados falsos (mock)
    let mockViewModel = HomeViewModel(
        spotifyService: MockSpotifyService()
    )
    return HomeView(viewModel: mockViewModel)
}
