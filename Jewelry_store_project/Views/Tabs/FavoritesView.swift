import SwiftUI

struct FavoritesView: View {

    @Environment(FavoritesStore.self) private var favorites

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        Group {
            if favorites.favoriteProducts.isEmpty {
                ContentUnavailableView(
                    "No favorites yet",
                    systemImage: "heart",
                    description: Text(
                        "Tap the heart on a product on the home screen to save it here."
                    )
                )
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(favorites.favoriteProducts) { product in
                            ProductNavigationLink(product: product) {
                                ProductGridCard(product: product)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 100)
                }
            }
        }
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.large)
        .appScreenBackground()
    }
}
