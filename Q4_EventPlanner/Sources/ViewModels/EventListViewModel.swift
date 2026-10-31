import SwiftUI
import SwiftData

/// ViewModel de la pantalla de listado: controla qué hoja se muestra y borra eventos.
final class EventListViewModel: ObservableObject {
    @Published var showingNewEvent = false
    @Published var eventToEdit: Event?

    func formattedDate(_ date: Date) -> String {
        date.formatted(date: .abbreviated, time: .shortened)
    }

    func delete(_ event: Event, in context: ModelContext) {
        context.delete(event)
        try? context.save()
    }
}
