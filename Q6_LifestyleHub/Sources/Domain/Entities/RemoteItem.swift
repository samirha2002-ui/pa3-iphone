import Foundation

/// Elemento descargado del servicio externo (para la cuadrícula del módulo Explorar).
struct RemoteItem: Identifiable, Equatable {
    let id: Int
    let title: String
    let category: String
    let price: Double
    let imageURL: URL?
}
