import SwiftUI
import SwiftData

struct EventListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Event.date) private var events: [Event]
    @StateObject private var viewModel = EventListViewModel()

    var body: some View {
        NavigationStack {
            List {
                ForEach(events) { event in
                    EventRowView(event: event, dateText: viewModel.formattedDate(event.date))
                        .contentShape(Rectangle())
                        .onTapGesture { viewModel.eventToEdit = event }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                viewModel.delete(event, in: modelContext)
                            } label: {
                                Label("Eliminar", systemImage: "trash")
                            }
                        }
                }
            }
            .overlay {
                if events.isEmpty {
                    ContentUnavailableView("Sin eventos",
                                           systemImage: "calendar.badge.plus",
                                           description: Text("Toca + para crear tu primer evento."))
                }
            }
            .navigationTitle("Event Planner Pro")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.showingNewEvent = true
                    } label: {
                        Label("Nuevo evento", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingNewEvent) {
                EventFormView(event: nil)
            }
            .sheet(item: $viewModel.eventToEdit) { event in
                EventFormView(event: event)
            }
        }
    }
}
