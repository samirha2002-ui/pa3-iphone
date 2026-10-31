import Foundation
import SwiftData

/// Modelo de persistencia (capa Data). Es distinto de la entidad de dominio Activity.
@Model
final class ActivityEntity {
    @Attribute(.unique) var id: UUID
    var title: String
    var notes: String
    var date: Date
    var isDone: Bool

    init(id: UUID, title: String, notes: String, date: Date, isDone: Bool) {
        self.id = id
        self.title = title
        self.notes = notes
        self.date = date
        self.isDone = isDone
    }
}
