import SwiftUI

struct ActivitiesView: View {
    @EnvironmentObject private var viewModel: ActivitiesViewModel
    @AppStorage("userName") private var userName = ""

    @State private var showingNew = false
    @State private var activityToEdit: Activity?

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.activities) { activity in
                    HStack(spacing: 12) {
                        Button {
                            viewModel.toggleDone(activity)
                        } label: {
                            Image(systemName: activity.isDone ? "checkmark.circle.fill" : "circle")
                                .font(.title2)
                        }
                        .buttonStyle(.borderless)

                        VStack(alignment: .leading, spacing: 3) {
                            Text(activity.title)
                                .font(.headline)
                                .strikethrough(activity.isDone)
                            if !activity.notes.isEmpty {
                                Text(activity.notes)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                            }
                            Text(activity.date.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture { activityToEdit = activity }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            viewModel.delete(activity)
                        } label: {
                            Label("Eliminar", systemImage: "trash")
                        }
                    }
                }
            }
            .overlay {
                if viewModel.activities.isEmpty {
                    ContentUnavailableView("Sin actividades",
                                           systemImage: "checklist",
                                           description: Text("Toca + para agregar una actividad."))
                }
            }
            .navigationTitle(userName.isEmpty ? "Mis actividades" : "Hola, \(userName)")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingNew = true
                    } label: {
                        Label("Nueva actividad", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNew) {
                ActivityFormView(activity: nil)
            }
            .sheet(item: $activityToEdit) { activity in
                ActivityFormView(activity: activity)
            }
        }
    }
}
