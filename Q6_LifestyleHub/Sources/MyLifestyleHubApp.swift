import SwiftUI
import SwiftData

/// Raíz de composición: aquí se arman las capas (Data -> Domain -> Presentation).
@main
struct MyLifestyleHubApp: App {
    private let container: ModelContainer

    @StateObject private var activitiesVM: ActivitiesViewModel
    @StateObject private var exploreVM: RemoteItemsViewModel
    @StateObject private var mediaVM = MediaViewModel()
    @StateObject private var themeVM = ThemeViewModel()

    init() {
        let container = try! ModelContainer(for: ActivityEntity.self)
        self.container = container

        let activityRepository = SwiftDataActivityRepository(context: container.mainContext)
        let activityUseCases = ManageActivitiesUseCase(repository: activityRepository)
        _activitiesVM = StateObject(wrappedValue: ActivitiesViewModel(useCases: activityUseCases))

        let remoteUseCase = FetchRemoteItemsUseCase(repository: RemoteItemsRepositoryImpl())
        _exploreVM = StateObject(wrappedValue: RemoteItemsViewModel(useCase: remoteUseCase))
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(activitiesVM)
                .environmentObject(exploreVM)
                .environmentObject(mediaVM)
                .environmentObject(themeVM)
                .tint(themeVM.color)
        }
    }
}
