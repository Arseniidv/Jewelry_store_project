import Foundation
import Observation

@Observable
class AppNotificationManager {
    var notifications: [AppNotification] = AppNotification.samples

    func markAllAsRead() {
        for index in notifications.indices {
            notifications[index].isRead = true
        }
    }
}
