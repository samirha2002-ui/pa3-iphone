import SwiftUI

/// Guarda el color elegido por el usuario y lo recuerda aunque se cierre la app.
final class ThemeViewModel: ObservableObject {
    private static let key = "themeColorHex"

    @Published var color: Color {
        didSet {
            UserDefaults.standard.set(color.toHex(), forKey: ThemeViewModel.key)
        }
    }

    init() {
        let hex = UserDefaults.standard.string(forKey: ThemeViewModel.key) ?? "0A84FF"
        color = Color(hex: hex)
    }
}
