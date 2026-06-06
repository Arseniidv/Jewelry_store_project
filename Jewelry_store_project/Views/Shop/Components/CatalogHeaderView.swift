import SwiftUI

struct CatalogHeaderView: View {
    let onFilterTap: () -> Void
    let filterIsActive: Bool

    var body: some View {
        HStack(spacing: 12) {
            Spacer()

            Button(action: onFilterTap) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(filterIsActive ? AppTheme.onAccent : AppTheme.primaryText)
                    .frame(width: 44, height: 44)
                    .background(filterIsActive ? AppTheme.accentDark : AppTheme.surfaceMuted)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)

            NotificationBellButton(iconSize: 18)
        }
    }
}
