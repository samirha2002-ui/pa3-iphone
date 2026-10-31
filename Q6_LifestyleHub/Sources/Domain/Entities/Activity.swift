import Foundation

/// Entidad de dominio: una actividad del usuario. No depende de SwiftUI ni de SwiftData.
struct Activity: Identifiable, Equatable {
    let id: UUID
    var title: String
    var notes: String
    var date: Date
    var isDone: Bool

    init(id: UUID = UUID(), title: String, notes: String = "", date: Date = Date(), isDone: Bool = false) {
        self.id = id
        self.title = title
        self.notes = notes
        self.date = date
        self.isDone = isDone
    }
}
