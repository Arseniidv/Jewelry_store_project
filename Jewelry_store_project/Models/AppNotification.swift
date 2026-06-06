import Foundation

struct AppNotification: Identifiable, Codable {
    let id: String
    var title: String
    var body: String
    let timestamp: Date
    var isRead: Bool
    let type: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case body
        case timestamp
        case isRead = "is_read"
        case type
    }
}

extension AppNotification {
    init?(userInfo: [AnyHashable: Any]) {
        guard let title = userInfo["title"] as? String,
              let body = userInfo["body"] as? String
        else { return nil }
        self.id = (userInfo["notification_id"] as? String) ?? UUID().uuidString
        self.title = title
        self.body = body
        self.timestamp = Date.now
        self.isRead = false
        self.type = userInfo["notification_type"] as? String
    }
}

extension AppNotification {
    static let samples: [AppNotification] = [
        AppNotification(
            id: "sample-1",
            title: "Order Shipped",
            body: "Your Diamond Solitaire Ring is on the way.",
            timestamp: Date.now.addingTimeInterval(-120),
            isRead: false,
            type: "order"
        ),
        AppNotification(
            id: "sample-2",
            title: "New Collection",
            body: "Summer Vibes just dropped — explore new pieces.",
            timestamp: Date.now.addingTimeInterval(-3600),
            isRead: false,
            type: "collection"
        ),
        AppNotification(
            id: "sample-3",
            title: "Special Offer",
            body: "15% off earrings this weekend only.",
            timestamp: Date.now.addingTimeInterval(-86400),
            isRead: true,
            type: "offer"
        ),
    ]
}
