import SwiftUI

struct NotificationView: View {

    let notifications: [AppNotification]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(notifications) { notification in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(notification.title)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(AppTheme.primaryText)

                            Spacer()

                            Text(relativeTime(for: notification.timestamp))
                                .font(.system(size: 12))
                                .foregroundStyle(AppTheme.secondaryText)
                        }

                        Text(notification.body)
                            .font(.system(size: 14))
                            .foregroundStyle(AppTheme.secondaryText)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(notification.isRead ? Color.clear : AppTheme.surfaceMuted)
                    )
                    .overlay(alignment: .topLeading) {
                        if !notification.isRead {
                            Circle()
                                .fill(.blue)
                                .frame(width: 8, height: 8)
                                .padding([.top, .leading], 8)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Уведомления")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func relativeTime(for date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date.now)
    }
}
