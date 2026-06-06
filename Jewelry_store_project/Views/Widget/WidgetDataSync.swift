import WidgetKit
import Foundation

enum WidgetDataSync {
    private static let defaults = UserDefaults(suiteName: "group.com.jewelrystore")

    static func updateLatestNotification(title: String, body: String) {
        defaults?.set(title, forKey: "widget_latest_title")
        defaults?.set(body, forKey: "widget_latest_body")
        defaults?.synchronize()
        WidgetCenter.shared.reloadTimelines(ofKind: "JewelryNotificationsWidget")
    }
}
