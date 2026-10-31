import Foundation
import SwiftData

/// Implementación del contrato ActivityRepository usando SwiftData.
final class SwiftDataActivityRepository: ActivityRepository {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchAll() throws -> [Activity] {
        let descriptor = FetchDescriptor<ActivityEntity>(sortBy: [SortDescriptor(\.date)])
        return try context.fetch(descriptor).map {
            Activity(id: $0.id, title: $0.title, notes: $0.notes, date: $0.date, isDone: $0.isDone)
        }
    }

    func save(_ activity: Activity) throws {
        if let existing = try find(activity.id) {
            existing.title = activity.title
            existing.notes = activity.notes
            existing.date = activity.date
            existing.isDone = activity.isDone
        } else {
            context.insert(ActivityEntity(id: activity.id,
                                          title: activity.title,
                                          notes: activity.notes,
                                          date: activity.date,
                                          isDone: activity.isDone))
        }
        try context.save()
    }

    func delete(id: UUID) throws {
        if let existing = try find(id) {
            context.delete(existing)
            try context.save()
        }
    }

    private func find(_ id: UUID) throws -> ActivityEntity? {
        let descriptor = FetchDescriptor<ActivityEntity>(predicate: #Predicate<ActivityEntity> { $0.id == id })
        return try context.fetch(descriptor).first
    }
}
