import SwiftUI

@MainActor
final class ActivitiesViewModel: ObservableObject {
    @Published private(set) var activities: [Activity] = []
    @Published var errorMessage: String?

    private let useCases: ManageActivitiesUseCase

    init(useCases: ManageActivitiesUseCase) {
        self.useCases = useCases
        load()
    }

    func load() {
        do {
            activities = try useCases.list()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func save(_ activity: Activity) {
        perform { try useCases.save(activity) }
    }

    func delete(_ activity: Activity) {
        perform { try useCases.delete(activity) }
    }

    func toggleDone(_ activity: Activity) {
        perform { try useCases.toggleDone(activity) }
    }

    private func perform(_ action: () throws -> Void) {
        do {
            try action()
            load()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
