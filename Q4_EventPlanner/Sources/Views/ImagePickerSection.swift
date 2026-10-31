import SwiftUI
import PhotosUI

/// Vista hija: recibe la imagen del formulario con @Binding y la actualiza
/// cuando el usuario elige una foto con PhotosPicker.
struct ImagePickerSection: View {
    @Binding var imageData: Data?
    @State private var selectedItem: PhotosPickerItem?

    var body: some View {
        Group {
            if let data = imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 160)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            PhotosPicker(selection: $selectedItem, matching: .images) {
                Label(imageData == nil ? "Elegir imagen" : "Cambiar imagen",
                      systemImage: "photo")
            }

            if imageData != nil {
                Button("Quitar imagen", role: .destructive) {
                    imageData = nil
                    selectedItem = nil
                }
            }
        }
        .onChange(of: selectedItem) { _, newItem in
            guard let newItem else { return }
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self) {
                    imageData = data
                }
            }
        }
    }
}
