import Foundation
import SwiftData

@Model
final class Event {
    var title: String
    var details: String                       // descripción del evento
    var date: Date
    var colorHex: String                      // color representativo (ej. "FF8A65")
    @Attribute(.externalStorage) var imageData: Data?   // imagen asociada

    init(title: String, details: String, date: Date, colorHex: String, imageData: Data? = nil) {
        self.title = title
        self.details = details
        self.date = date
        self.colorHex = colorHex
        self.imageData = imageData
    }
}
