import SwiftUI

@MainActor
final class MovieViewModel: ObservableObject {
    enum State {
        case loading
        case loaded
        case failed(String)
    }

    @Published private(set) var state: State = .loading
    @Published private(set) var movies: [Movie] = []
    @Published var searchText = ""

    private let service: MovieService

    init(service: MovieService = MovieService()) {
        self.service = service
    }

    /// Búsqueda local: filtra las películas ya descargadas, sin volver a llamar a la API.
    var filteredMovies: [Movie] {
        let query = searchText.trimmingCharacters(in: .whitespaces)
        guard !query.isEmpty else { return movies }
        return movies.filter {
            $0.trackName.localizedCaseInsensitiveContains(query)
            || ($0.primaryGenreName ?? "").localizedCaseInsensitiveContains(query)
        }
    }

    func load() async {
        state = .loading
        do {
            movies = try await service.fetchMovies()
            state = .loaded
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
