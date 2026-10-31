import Foundation

enum MovieServiceError: LocalizedError {
    case invalidURL
    case badStatus(Int)
    case simulated

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "La dirección del servicio no es válida."
        case .badStatus(let code):
            return "El servidor respondió con el código \(code)."
        case .simulated:
            return "No se pudo conectar con el servidor. Revisa tu conexión e inténtalo otra vez."
        }
    }
}

struct MovieService {
    /// Descarga una colección de películas desde la API pública de búsqueda de iTunes (sin clave).
    func fetchMovies(term: String = "action") async throws -> [Movie] {
        // Banderas de prueba: permiten mostrar el estado de carga y de error en las capturas.
        let arguments = ProcessInfo.processInfo.arguments
        if arguments.contains("-simulate-slow") {
            try await Task.sleep(nanoseconds: 12_000_000_000)
        }
        if arguments.contains("-simulate-error") {
            throw MovieServiceError.simulated
        }

        var components = URLComponents(string: "https://itunes.apple.com/search")
        components?.queryItems = [
            URLQueryItem(name: "term", value: term),
            URLQueryItem(name: "media", value: "movie"),
            URLQueryItem(name: "limit", value: "60")
        ]
        guard let url = components?.url else { throw MovieServiceError.invalidURL }

        let (data, response) = try await URLSession.shared.data(from: url)
        if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
            throw MovieServiceError.badStatus(http.statusCode)
        }
        return try JSONDecoder().decode(MovieResponse.self, from: data).results
    }
}
