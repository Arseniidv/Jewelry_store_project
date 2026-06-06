import WidgetKit
import SwiftUI

// MARK: - Entry

struct NotificationEntry: TimelineEntry {
    let date: Date
    let title: String
    let body: String
}

// MARK: - Provider

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> NotificationEntry {
        NotificationEntry(
            date: Date(),
            title: "No updates",
            body: "You are all caught up"
        )
    }

    private func readEntry() -> NotificationEntry {
        let defaults = UserDefaults(suiteName: "group.com.jewelrystore")
        let title = defaults?.string(forKey: "last_title")
                 ?? defaults?.string(forKey: "widget_latest_title")
                 ?? "No updates"
        let body = defaults?.string(forKey: "last_body")
                 ?? defaults?.string(forKey: "widget_latest_body")
                 ?? "You are all caught up"
        return NotificationEntry(date: Date(), title: title, body: body)
    }

    func getSnapshot(in context: Context, completion: @escaping (NotificationEntry) -> Void) {
        guard !context.isPreview else {
            completion(placeholder(in: context))
            return
        }
        completion(readEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<NotificationEntry>) -> Void) {
        let timeline = Timeline(entries: [readEntry()], policy: .atEnd)
        completion(timeline)
    }
}

// MARK: - View

struct JewelryNotificationsWidgetEntryView: View {
    var entry: NotificationEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 8, height: 8)
                Text("Latest Update")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.secondary)
            }

            Text(entry.title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.primary)
                .lineLimit(1)

            Text(entry.body)
                .font(.system(size: 13))
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .containerBackground(.background, for: .widget)
    }
}

// MARK: - Widget

struct JewelryNotificationsWidget: Widget {
    let kind: String = "JewelryNotificationsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            JewelryNotificationsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Store Updates")
        .description("Stay updated with your order status and exclusive jewelry collection drops.")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    JewelryNotificationsWidget()
} timeline: {
    NotificationEntry(date: .now, title: "Order Shipped", body: "Your diamond ring has been dispatched and will arrive within 3-5 business days.")
    NotificationEntry(date: .now, title: "New Collection", body: "Explore our latest gemstone collection featuring emeralds and sapphires.")
}
