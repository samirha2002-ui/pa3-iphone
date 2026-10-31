import Foundation

struct FetchRemoteItemsUseCase {
    let repository: RemoteItemsRepository

    func execute() async throws -> [RemoteItem] {
        try await repository.fetchItems()
    }
}
