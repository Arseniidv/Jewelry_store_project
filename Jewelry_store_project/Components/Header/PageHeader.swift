import SwiftUI

struct PageHeader: View {

    @Binding var selectedTab: MainTab
    @Environment(AuthManager.self) private var authManager

    var body: some View {
        HStack {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(AppTheme.surfaceMuted)
                        .frame(width: 50, height: 50)

                    Image(systemName: authManager.currentUser?.avatarName ?? "person.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 28, height: 28)
                        .foregroundStyle(AppTheme.accentDark)
                        .clipShape(Circle())
                }
                .onTapGesture {
                    selectedTab = .profile
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Welcome")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(AppTheme.secondaryText)

                    Text(authManager.currentUser?.name ?? "User")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(AppTheme.primaryText)
                }
                .onTapGesture {
                    selectedTab = .profile
                }
            }

            Spacer()

            NotificationBellButton()
        }
    }
}

#Preview {
    PageHeader(selectedTab: .constant(.home))
        .padding()
        .environment(AuthManager())
        .environment(AppNotificationManager())
}
