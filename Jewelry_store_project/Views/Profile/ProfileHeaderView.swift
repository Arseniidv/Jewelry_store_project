import SwiftUI

struct ProfileHeaderView: View {
    let username: String
    let email: String
    let avatarName: String
    let onAvatarTap: (() -> Void)?
    let onEditTap: (() -> Void)?

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(AppTheme.surfaceMuted)
                    .frame(width: 110, height: 110)

                Image(systemName: avatarName)
                    .font(.system(size: 42))
                    .foregroundStyle(AppTheme.accentDark)
            }
            .onTapGesture {
                onAvatarTap?()
            }

            VStack(spacing: 6) {
                Text(username)
                    .font(.title2)
                    .fontWeight(.semibold)

                Text(email)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Button {
                onEditTap?()
            } label: {
                Text("Редактировать профиль")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .clipShape(Capsule())
            }
        }
    }
}
