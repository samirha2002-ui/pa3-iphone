import Foundation

/// Casos de uso del módulo Actividades: reglas de la aplicación en un solo lugar.
struct ManageActivitiesUseCase {
    let repository: ActivityRepository

    func list() throws -> [Activity] {
        try repository.fetchAll()
    }

    func save(_ activity: Activity) throws {
        try repository.save(activity)
    }

    func delete(_ activity: Activity) throws {
        try repository.delete(id: activity.id)
    }

    func toggleDone(_ activity: Activity) throws {
        var updated = activity
        updated.isDone.toggle()
        try repository.save(updated)
    }
}
