import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        NavigationStack {
            List(viewModel.recentTracks, id: \.id) { track in
                VStack(alignment: .leading) {
                    Text(track.name)
                        .bold()
                    Text(track.artist)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }
            .task {
                await viewModel.load()
            }
            .navigationTitle("Músicas Recentes")
            .task {
                await viewModel.load()
            }
        }
    }
}


