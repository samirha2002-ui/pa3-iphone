import SwiftUI

struct PersonalizationView: View {
    @EnvironmentObject private var theme: ThemeViewModel
    @EnvironmentObject private var activities: ActivitiesViewModel
    @AppStorage("userName") private var userName = ""

    @State private var plannedTitle = ""
    @State private var plannedDate = Date()
    @State private var confirmation = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Apariencia") {
                    ColorPicker("Color del tema", selection: $theme.color, supportsOpacity: false)
                    TextField("Tu nombre", text: $userName)
                }

                Section("Programar actividad") {
                    TextField("¿Qué quieres hacer?", text: $plannedTitle)
                    DatePicker("Fecha y hora", selection: $plannedDate)
                    Button("Programar") {
                        activities.save(Activity(title: plannedTitle, date: plannedDate))
                        confirmation = "Actividad programada: \(plannedTitle)"
                        plannedTitle = ""
                    }
                    .disabled(plannedTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                    if !confirmation.isEmpty {
                        Label(confirmation, systemImage: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    }
                }
            }
            .navigationTitle("Personalizar")
        }
    }
}
