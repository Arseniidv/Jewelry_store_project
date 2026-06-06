import UIKit
import UserNotifications
import SwiftData
import Observation
import WidgetKit

@Observable
final class NotificationService: NSObject {
    private(set) var pendingDeepLink: DeepLink?
    private var modelContext: ModelContext?

    func configure(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func clearDeepLink() {
        pendingDeepLink = nil
    }

    func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            guard granted else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    func parsePayload(_ userInfo: [AnyHashable: Any]) -> DeepLink {
        guard let type = userInfo["type"] as? String else { return .unknown }
        switch type {
        case "product":
            guard let id = userInfo["id"] as? String, !id.isEmpty else { return .unknown }
            return .product(id: id)
        default:
            return .unknown
        }
    }

    func handleNotificationResponse(_ response: UNNotificationResponse) {
        let deepLink = parsePayload(response.notification.request.content.userInfo)
        guard deepLink != .unknown else { return }
        pendingDeepLink = deepLink
    }

    // MARK: - SwiftData operations

    func saveNotification(from dto: AppNotification) {
        guard let modelContext else { return }
        let entity = NotificationEntity(
            id: dto.id,
            title: dto.title,
            bodyText: dto.body,
            timestamp: dto.timestamp,
            isRead: dto.isRead,
            typeRaw: dto.type
        )
        modelContext.insert(entity)
        try? modelContext.save()
        WidgetDataSync.updateLatestNotification(title: dto.title, body: dto.body)
    }

    func markAsRead(id: String) {
        guard let modelContext else { return }
        let predicate = #Predicate<NotificationEntity> { $0.id == id }
        let descriptor = FetchDescriptor(predicate: predicate)
        guard let entity = try? modelContext.fetch(descriptor).first else { return }
        entity.isRead = true
        try? modelContext.save()
        updateAppBadgeAndWidgets()
    }

    func markAllAsRead() {
        guard let modelContext else { return }
        let predicate = #Predicate<NotificationEntity> { !$0.isRead }
        let descriptor = FetchDescriptor(predicate: predicate)
        guard let entities = try? modelContext.fetch(descriptor) else { return }
        for entity in entities {
            entity.isRead = true
        }
        try? modelContext.save()
        updateAppBadgeAndWidgets()
    }

    func deleteNotification(id: String) {
        guard let modelContext else { return }
        let predicate = #Predicate<NotificationEntity> { $0.id == id }
        let descriptor = FetchDescriptor(predicate: predicate)
        guard let entity = try? modelContext.fetch(descriptor).first else { return }
        modelContext.delete(entity)
        try? modelContext.save()

        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [id])
        updateAppBadgeAndWidgets()
    }

    func deleteNotification(_ entity: NotificationEntity) {
        guard let modelContext else { return }
        modelContext.delete(entity)
        try? modelContext.save()

        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [entity.id])
        updateAppBadgeAndWidgets()
    }

    func clearAllNotifications() {
        guard let modelContext else { return }
        let predicate = #Predicate<NotificationEntity> { _ in true }
        let descriptor = FetchDescriptor(predicate: predicate)
        guard let entities = try? modelContext.fetch(descriptor) else { return }
        for entity in entities {
            modelContext.delete(entity)
        }
        try? modelContext.save()

        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        updateAppBadgeAndWidgets()
    }

    func updateAppBadgeAndWidgets() {
        guard let modelContext else { return }
        let predicate = #Predicate<NotificationEntity> { !$0.isRead }
        let descriptor = FetchDescriptor(predicate: predicate)
        let unreadCount = (try? modelContext.fetch(descriptor).count) ?? 0
        UNUserNotificationCenter.current().setBadgeCount(unreadCount)
        reloadWidgetTimelines()
    }

    private func reloadWidgetTimelines() {
    }
}

extension NotificationService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        let userInfo = notification.request.content.userInfo
        if let dto = AppNotification(userInfo: userInfo) {
            saveNotification(from: dto)
            pendingDeepLink = parsePayload(userInfo)
        }
        completionHandler([.banner, .sound, .badge])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        if let dto = AppNotification(userInfo: userInfo) {
            saveNotification(from: dto)
        }
        handleNotificationResponse(response)
        completionHandler()
    }
}
