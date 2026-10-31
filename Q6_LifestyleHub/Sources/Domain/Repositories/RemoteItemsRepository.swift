import Foundation

protocol RemoteItemsRepository {
    func fetchItems() async throws -> [RemoteItem]
}
