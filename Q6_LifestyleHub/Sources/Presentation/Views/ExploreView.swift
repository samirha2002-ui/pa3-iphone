import SwiftUI

struct ExploreView: View {
    @EnvironmentObject private var viewModel: RemoteItemsViewModel

    private let columns = [GridItem(.adaptive(minimum: 150), spacing: 16)]

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Explorar")
        }
        .task {
            if viewModel.items.isEmpty {
                await viewModel.load()
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            VStack(spacing: 16) {
                ProgressView()
                    .controlSize(.large)
                Text("Cargando contenido…")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .failed(let message):
            ContentUnavailableView {
                Label("Sin conexión", systemImage: "wifi.exclamationmark")
            } description: {
                Text(message)
            } actions: {
                Button("Reintentar") {
                    Task { await viewModel.load() }
                }
                .buttonStyle(.borderedProminent)
            }

        case .loaded:
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.items) { item in
                        VStack(alignment: .leading, spacing: 6) {
                            AsyncImage(url: item.imageURL) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                case .failure:
                                    Image(systemName: "photo")
                                        .font(.largeTitle)
                                        .foregroundStyle(.secondary)
                                default:
                                    ProgressView()
                                }
                            }
                            .frame(height: 140)
                            .frame(maxWidth: .infinity)
                            .background(.quaternary)
                            .clipShape(RoundedRectangle(cornerRadius: 12))

                            Text(item.title)
                                .font(.subheadline.bold())
                                .lineLimit(2)
                            Text(item.category.capitalized)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(item.price, format: .currency(code: "USD"))
                                .font(.caption.weight(.semibold))
                        }
                    }
                }
                .padding()
            }
        }
    }
}
