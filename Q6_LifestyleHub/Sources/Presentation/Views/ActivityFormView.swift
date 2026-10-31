import SwiftUI

struct ActivityFormView: View {
    @EnvironmentObject private var viewModel: ActivitiesViewModel
    @Environment(\.dismiss) private var dismiss

    private let original: Activity?
    @State private var title: String
    @State private var notes: String
    @State private var date: Date

    init(activity: Activity?) {
        self.original = activity
        _title = State(initialValue: activity?.title ?? "")
        _notes = State(initialValue: activity?.notes ?? "")
        _date = State(initialValue: activity?.date ?? Date())
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Actividad") {
                    TextField("Título", text: $title)
                    TextField("Notas", text: $notes, axis: .vertical)
                        .lineLimit(2...5)
                }
                Section("Fecha") {
                    DatePicker("Fecha y hora", selection: $date)
                }
            }
            .navigationTitle(original == nil ? "Nueva actividad" : "Editar actividad")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        var activity = original ?? Activity(title: title)
                        activity.title = title
                        activity.notes = notes
                        activity.date = date
                        viewModel.save(activity)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
