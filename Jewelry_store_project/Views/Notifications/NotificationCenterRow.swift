import SwiftUI

struct NotificationCenterRow: View {
    let entity: NotificationEntity

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Circle()
                .fill(entity.isRead ? Color.clear : Color.blue)
                .frame(width: 10, height: 10)
                .padding(.top, 6)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(entity.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(AppTheme.primaryText)
                    Spacer()
                    Text(relativeTime)
                        .font(.system(size: 12))
                        .foregroundStyle(AppTheme.secondaryText)
                }

                Text(entity.bodyText)
                    .font(.system(size: 14))
                    .foregroundStyle(AppTheme.secondaryText)
                    .lineLimit(2)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(entity.isRead ? Color.clear : AppTheme.surfaceMuted)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(entity.isRead ? AppTheme.surfaceMuted : Color.clear, lineWidth: 1)
        )
    }

    private var relativeTime: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: entity.timestamp, relativeTo: Date.now)
    }
}
