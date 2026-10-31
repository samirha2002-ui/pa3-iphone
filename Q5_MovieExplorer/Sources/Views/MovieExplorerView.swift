import SwiftUI

struct MovieExplorerView: View {
    @StateObject private var viewModel = MovieViewModel()

    // Cuadrícula adaptable: las columnas se ajustan solas al ancho de la pantalla.
    private let columns = [GridItem(.adaptive(minimum: 150), spacing: 16)]

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Movie Explorer")
                .searchable(text: $viewModel.searchText, prompt: "Buscar película")
        }
        .task {
            await viewModel.load()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            VStack(spacing: 16) {
                ProgressView()
                    .controlSize(.large)
                Text("Cargando películas…")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .failed(let message):
            ContentUnavailableView {
                Label("No se pudo cargar", systemImage: "wifi.exclamationmark")
            } description: {
                Text(message)
            } actions: {
                Button("Reintentar") {
                    Task { await viewModel.load() }
                }
                .buttonStyle(.borderedProminent)
            }

        case .loaded:
            if viewModel.filteredMovies.isEmpty {
                ContentUnavailableView("Sin resultados",
                                       systemImage: "film",
                                       description: Text("No hay películas que coincidan con tu búsqueda."))
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.filteredMovies) { movie in
                            MovieCardView(movie: movie)
                        }
                    }
                    .padding()
                }
            }
        }
    }
}
