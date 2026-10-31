import SwiftUI
import SwiftData

struct EventFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: EventFormViewModel

    init(event: Event?) {
        _viewModel = StateObject(wrappedValue: EventFormViewModel(event: event))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Información") {
                    TextField("Título", text: $viewModel.title)
                    TextField("Descripción", text: $viewModel.details, axis: .vertical)
                        .lineLimit(2...5)
                }

                Section("Fecha y color") {
                    DatePicker("Fecha del evento",
                               selection: $viewModel.date,
                               displayedComponents: [.date, .hourAndMinute])
                    ColorPicker("Color representativo",
                                selection: $viewModel.color,
                                supportsOpacity: false)
                }

                Section("Imagen") {
                    // Vista hija que modifica el dato del padre mediante @Binding
                    ImagePickerSection(imageData: $viewModel.imageData)
                }
            }
            .navigationTitle(viewModel.isEditing ? "Editar evento" : "Nuevo evento")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        viewModel.save(in: modelContext)
                        dismiss()
                    }
                    .disabled(!viewModel.canSave)
                }
            }
        }
    }
}
