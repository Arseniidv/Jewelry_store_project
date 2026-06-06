import SwiftUI

struct ContentView: View {
    @State private var selectedTab: MainTab = .home
    @State private var navigationPath = NavigationPath()
    @State private var favoritesStore = FavoritesStore()
    @State private var appChrome = AppChromeState()
    @Environment(NotificationService.self) private var notificationService
    @Environment(\.productCatalog) private var catalog

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack(alignment: .bottom) {
                tabRoot
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                if !appChrome.isBottomBarHidden {
                    BottomNavigationView(
                        selectedTab: $selectedTab
                    )
                    .padding(.bottom, 12)
                    .transition(
                        .move(edge: .bottom)
                        .combined(with: .opacity)
                    )
                }
            }
            .animation(
                .easeInOut(duration: 0.25),
                value: appChrome.isBottomBarHidden
            )
            .appScreenBackground()

            .navigationDestination(for: HomeSectionRoute.self) { route in
                ProductListView(route: route)
            }

            .navigationDestination(for: Product.self) { product in
                ProductDetailView(product: product)
            }

            .navigationDestination(for: ServiceCategory.self) { category in
                CategoryDetailView(category: category)
            }
        }

        .toolbarBackground(
            AppTheme.screenBackground,
            for: .navigationBar
        )

        .toolbarBackground(
            .visible,
            for: .navigationBar
        )

        .environment(favoritesStore)
        .environment(appChrome)

        .onChange(of: selectedTab) { _, _ in
            navigationPath = NavigationPath()
        }
        .onAppear {
            handlePendingDeepLink()
        }
        .onChange(of: notificationService.pendingDeepLink) { _, deepLink in
            guard let deepLink else { return }
            navigate(to: deepLink)
        }
    }

    @ViewBuilder
    private var tabRoot: some View {
        switch selectedTab {
        case .home:
            HomeView(selectedTab: $selectedTab)
        case .shop:
            ShopView()
        case .favorites:
            FavoritesView()
        case .profile:
            ProfileView()
        }
    }

    private func handlePendingDeepLink() {
        guard let deepLink = notificationService.pendingDeepLink else { return }
        navigate(to: deepLink)
    }

    private func navigate(to deepLink: DeepLink) {
        selectedTab = .shop
        switch deepLink {
        case .product(let id):
            guard let product = catalog.product(forID: id) else { return }
            navigationPath.append(product)
        case .unknown:
            break
        }
        notificationService.clearDeepLink()
    }
}

// MARK: - Preview

#Preview {
    ContentView()
        .environment(FavoritesStore())
        .environment(AppChromeState())
        .environment(AuthManager())
        .environment(\.productCatalog, ProductCatalogService.shared)
        .environment(NotificationService())
}
