import SwiftUI

struct ProfileItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let destination: AnyView

    init(icon: String, title: String, destination: AnyView) {
        self.icon = icon
        self.title = title
        self.destination = destination
    }
}

struct ProfileSectionView: View {
    let title: String
    let items: [ProfileItem]
    let onItemTap: (ProfileItem) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.headline)
                .foregroundStyle(AppTheme.primaryText)
                .padding(.horizontal)

            VStack(spacing: 0) {
                ForEach(items) { item in
                    ProfileMenuItem(
                        action: { onItemTap(item) },
                        icon: item.icon,
                        title: item.title
                    )

                    if item.id != items.last?.id {
                        Divider()
                            .overlay(AppTheme.surfaceMuted)
                            .padding(.leading, 52)
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .fill(AppTheme.surfaceMuted)
            )
            .padding(.horizontal)
        }
    }
}

struct ProfileView: View {
    @Environment(FavoritesStore.self) private var favoritesStore
    @Environment(AuthManager.self) private var authManager
    @State private var showAvatarPicker = false
    @State private var showLogoutAlert = false

    private var user: StoredUser? { authManager.currentUser }

    private var accountItems: [ProfileItem] {
        [
            ProfileItem(icon: "bag", title: "Мои заказы", destination: AnyView(OrdersView())),
            ProfileItem(icon: "heart", title: "Избранное", destination: AnyView(FavoritesView())),
            ProfileItem(icon: "location.circle.fill", title: "Адреса", destination: AnyView(AddressesView()))
        ]
    }

    private let settingsItems: [ProfileItem] = [
        ProfileItem(icon: "bell", title: "Уведомления", destination: AnyView(NotificationView(notifications: AppNotification.samples))),
        ProfileItem(icon: "lock", title: "Приватность", destination: AnyView(PrivacyView())),
        ProfileItem(icon: "gearshape", title: "Основные", destination: AnyView(SettingsView()))
    ]

    @State private var navigateToDestination: AnyView?
    @State private var isNavigating = false

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 28) {
                ProfileHeaderView(
                    username: user?.name ?? "User",
                    email: user?.email ?? "",
                    avatarName: user?.avatarName ?? "person.circle.fill",
                    onAvatarTap: { showAvatarPicker = true },
                    onEditTap: { }
                )
                .padding(.top, 8)

                ProfileSectionView(
                    title: "Аккаунт",
                    items: accountItems
                ) { item in
                    navigateToDestination = item.destination
                    isNavigating = true
                }

                ProfileSectionView(
                    title: "Настройки",
                    items: settingsItems
                ) { item in
                    navigateToDestination = item.destination
                    isNavigating = true
                }

                Button {
                    showLogoutAlert = true
                } label: {
                    Text("Выйти")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(AppTheme.surfaceMuted)
                        )
                }
                .padding(.horizontal)
                .padding(.bottom, 120)
            }
        }
        .navigationTitle("Профиль")
        .navigationBarTitleDisplayMode(.large)
        .appScreenBackground()
        .navigationDestination(isPresented: $isNavigating) {
            if let destination = navigateToDestination {
                destination.environment(favoritesStore)
            }
        }
        .sheet(isPresented: $showAvatarPicker) {
            if let user {
                AvatarPickerView(selected: Binding(
                    get: { user.avatarName },
                    set: { authManager.updateAvatar($0) }
                ))
            }
        }
        .alert("Выйти из аккаунта?", isPresented: $showLogoutAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Logout", role: .destructive) { authManager.logout() }
        } message: {
            Text("Are you sure you want to sign out?")
        }
    }
}

#Preview {
    ProfileView()
        .environment(FavoritesStore())
        .environment(AuthManager())
}
