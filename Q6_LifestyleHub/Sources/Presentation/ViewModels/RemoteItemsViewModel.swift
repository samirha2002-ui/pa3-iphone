import SwiftUI

@MainActor
final class RemoteItemsViewModel: ObservableObject {
    enum State {
        case idle
        case loading
        case loaded
        case failed(String)
    }

    @Published private(set) var state: State = .idle
    @Published private(set) var items: [RemoteItem] = []

    private let useCase: FetchRemoteItemsUseCase

    init(useCase: FetchRemoteItemsUseCase) {
        self.useCase = useCase
    }

    func load() async {
        state = .loading
        do {
            items = try await useCase.execute()
            state = .loaded
        } catch {
            state = .failed("No se pudo cargar el contenido. Revisa tu conexión e inténtalo otra vez.")
        }
    }
}
