import Foundation

struct Music: Identifiable {
    let id = UUID()
    let trackName: String
    let artistName: String
    let albumArtURL: String?
}
