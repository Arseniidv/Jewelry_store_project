import Foundation
import SwiftData

@Model
final class NotificationEntity {
    @Attribute(.unique) var id: String
    var title: String
    var bodyText: String
    var timestamp: Date
    var isRead: Bool
    var typeRaw: String?

    init(
        id: String,
        title: String,
        bodyText: String,
        timestamp: Date = .now,
        isRead: Bool = false,
        typeRaw: String? = nil
    ) {
        self.id = id
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.isRead = isRead
        self.typeRaw = typeRaw
    }
}
