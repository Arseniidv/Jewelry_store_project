import SwiftUI
import SwiftData
import UserNotifications

@main
struct Jewelry_store_projectApp: App {
    @State private var authManager = AuthManager()
    @State private var notificationService = NotificationService()
    private let catalog: ProductCatalogServing =
        ProductCatalogService.shared

    var body: some Scene {
        WindowGroup {
            AppContainerView()
                .environment(authManager)
                .environment(notificationService)
                .tint(AppTheme.accentDark)
                .environment(\.productCatalog, catalog)
        }
        .modelContainer(for: [StoredUser.self, NotificationEntity.self])
    }
}
