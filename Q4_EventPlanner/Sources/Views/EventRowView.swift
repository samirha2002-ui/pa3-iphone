import SwiftUI

/// Vista hija: dibuja una fila del listado (solo recibe datos, no los modifica).
struct EventRowView: View {
    let event: Event
    let dateText: String

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 3)
                .fill(Color(hex: event.colorHex))
                .frame(width: 6, height: 54)

            thumbnail

            VStack(alignment: .leading, spacing: 3) {
                Text(event.title)
                    .font(.headline)
                if !event.details.isEmpty {
                    Text(event.details)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                Text(dateText)
                    .font(.caption)
                    .foregroundStyle(Color(hex: event.colorHex))
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }

    @ViewBuilder
    private var thumbnail: some View {
        if let data = event.imageData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 54, height: 54)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        } else {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: event.colorHex).opacity(0.25))
                .frame(width: 54, height: 54)
                .overlay(
                    Image(systemName: "calendar")
                        .foregroundStyle(Color(hex: event.colorHex))
                )
        }
    }
}
