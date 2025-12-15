import Foundation

struct Music: Identifiable {
    let id = UUID()
    let trackName: String
    let artistName: String
    let albumName: String
    let albumArtURL: String?
    let playedAt: Date
}
