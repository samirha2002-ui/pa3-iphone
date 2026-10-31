import Foundation

/// Respuesta del servicio: un objeto con la colección de películas en "results".
struct MovieResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable, Identifiable, Hashable {
    let trackId: Int
    let trackName: String
    let artistName: String?
    let artworkUrl100: String?
    let primaryGenreName: String?
    let releaseDate: String?
    let longDescription: String?

    var id: Int { trackId }

    /// El servicio entrega una portada pequeña; se pide una versión más grande.
    var posterURL: URL? {
        guard let artworkUrl100 else { return nil }
        return URL(string: artworkUrl100.replacingOccurrences(of: "100x100bb", with: "400x400bb"))
    }

    var year: String {
        String((releaseDate ?? "").prefix(4))
    }
}
