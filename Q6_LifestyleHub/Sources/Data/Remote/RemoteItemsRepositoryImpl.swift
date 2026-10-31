import Foundation

/// Implementación que consume un JSON público (sin clave) con URLSession y async/await.
final class RemoteItemsRepositoryImpl: RemoteItemsRepository {

    func fetchItems() async throws -> [RemoteItem] {
        if ProcessInfo.processInfo.arguments.contains("-simulate-error") {
            throw URLError(.notConnectedToInternet)
        }
        guard let url = URL(string: "https://dummyjson.com/products?limit=30") else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        let dto = try JSONDecoder().decode(ProductsResponseDTO.self, from: data)
        return dto.products.map {
            RemoteItem(id: $0.id,
                       title: $0.title,
                       category: $0.category,
                       price: $0.price,
                       imageURL: $0.thumbnail.flatMap { URL(string: $0) })
        }
    }
}
