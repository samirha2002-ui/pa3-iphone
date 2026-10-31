import Foundation

/// DTO: copia fiel del JSON que entrega el servicio. Se traduce a RemoteItem antes de llegar al dominio.
struct ProductsResponseDTO: Decodable {
    let products: [ProductDTO]
}

struct ProductDTO: Decodable {
    let id: Int
    let title: String
    let category: String
    let price: Double
    let thumbnail: String?
}
