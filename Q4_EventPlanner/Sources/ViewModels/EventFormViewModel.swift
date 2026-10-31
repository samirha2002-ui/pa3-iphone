import SwiftUI
import SwiftData

/// ViewModel del formulario: sirve tanto para crear como para editar un evento.
final class EventFormViewModel: ObservableObject {
    @Published var title = ""
    @Published var details = ""
    @Published var date = Date()
    @Published var color = Color.blue
    @Published var imageData: Data?

    private let editingEvent: Event?

    var isEditing: Bool { editingEvent != nil }
    var canSave: Bool { !title.trimmingCharacters(in: .whitespaces).isEmpty }

    init(event: Event? = nil) {
        self.editingEvent = event
        if let event {
            title = event.title
            details = event.details
            date = event.date
            color = Color(hex: event.colorHex)
            imageData = event.imageData
        }
    }

    func save(in context: ModelContext) {
        if let event = editingEvent {
            event.title = title
            event.details = details
            event.date = date
            event.colorHex = color.toHex()
            event.imageData = imageData
        } else {
            context.insert(Event(title: title,
                                 details: details,
                                 date: date,
                                 colorHex: color.toHex(),
                                 imageData: imageData))
        }
        try? context.save()
    }
}
