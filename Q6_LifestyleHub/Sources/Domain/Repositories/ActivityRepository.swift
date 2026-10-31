import Foundation

/// Contrato que define QUÉ se puede hacer con las actividades.
/// El dominio no sabe si se guardan con SwiftData, Core Data o en un archivo.
protocol ActivityRepository {
    func fetchAll() throws -> [Activity]
    func save(_ activity: Activity) throws
    func delete(id: UUID) throws
}
