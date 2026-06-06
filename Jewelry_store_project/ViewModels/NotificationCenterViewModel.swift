import Foundation
import Observation

@Observable
final class NotificationCenterViewModel {
    private let notificationService: NotificationService

    init(notificationService: NotificationService) {
        self.notificationService = notificationService
    }

    // MARK: - Mutations

    func deleteNotification(_ entity: NotificationEntity) {
        notificationService.deleteNotification(entity)

        Task {
            try? await deleteFromBackend(id: entity.id)
        }
    }

    func deleteNotification(id: String) {
        notificationService.deleteNotification(id: id)

        Task {
            try? await deleteFromBackend(id: id)
        }
    }

    func markAsRead(_ entity: NotificationEntity) {
        notificationService.markAsRead(id: entity.id)
    }

    func markAllAsRead() {
        notificationService.markAllAsRead()
    }

    func clearAllNotifications() {
        notificationService.clearAllNotifications()

        Task {
            try? await clearAllOnServer()
        }
    }

    // MARK: - Backend API

    private func deleteFromBackend(id: String) async throws {
        let url = URL(string: "https://api.jewelrystore.com/notifications/\(id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode)
        else {
            throw URLError(.badServerResponse)
        }
    }

    private func clearAllOnServer() async throws {
        let url = URL(string: "https://api.jewelrystore.com/notifications/clear")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode)
        else {
            throw URLError(.badServerResponse)
        }
    }

    func deepLinkType(from typeRaw: String?) -> DeepLink? {
        guard let type = typeRaw else { return nil }
        switch type {
        case "product":
            return .product(id: "")
        default:
            return nil
        }
    }
}
