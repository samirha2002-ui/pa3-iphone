import SwiftUI
import SwiftData

@main
struct EventPlannerApp: App {
    var body: some Scene {
        WindowGroup {
            EventListView()
        }
        .modelContainer(for: Event.self)   // persistencia local con SwiftData
    }
}
