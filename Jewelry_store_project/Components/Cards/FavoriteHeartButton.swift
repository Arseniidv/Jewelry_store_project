import SwiftUI

/// Heart toggle that updates the shared favorites store (does not trigger parent navigation).
struct FavoriteHeartButton: View {
    let product: Product
    var iconFont: Font = .title3
    var foregroundWhenOff: Color = .white

    @Environment(FavoritesStore.self) private var favorites

    var body: some View {
        Button {
            favorites.toggle(product)
        } label: {
            Image(systemName: favorites.isFavorite(product) ? "heart.fill" : "heart")
                .font(iconFont)
                .foregroundStyle(favorites.isFavorite(product) ? .red : foregroundWhenOff)
                .padding(10)
                .background(.ultraThinMaterial, in: Circle())
                .padding(12)
        }
        .buttonStyle(.plain)
    }
}
