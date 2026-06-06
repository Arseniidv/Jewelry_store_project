import SwiftUI

/// Full list of product cards — opened only via the section header arrow.
struct ProductListView: View {
    let route: HomeSectionRoute

    private var products: [Product] { route.products() }

    var body: some View {
        GeometryReader { geometry in
            // ~25% of visible list area — half of the top half of the screen
            let cardHeight = geometry.size.height * 0.24

            ScrollView(.vertical, showsIndicators: true) {
                LazyVStack(spacing: 16) {
                    ForEach(products) { product in
                        ProductNavigationLink(product: product) {
                            ProductListCardView(
                                product: product,
                                subtitle: subtitle(for: product),
                                showsFavorite: route == .popularCollections
                            )
                            .frame(maxWidth: .infinity)
                            .frame(height: cardHeight)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
        }
        .navigationTitle(route.title)
        .navigationBarTitleDisplayMode(.large)
        .appScreenBackground()
    }

    private func subtitle(for product: Product) -> String {
        switch route {
        case .popularCollections: return product.collection
        case .popularCategory: return product.category.displayName
        }
    }
}

#Preview {
    NavigationStack {
        ProductListView(route: .popularCollections)
            .navigationDestination(for: Product.self) { ProductDetailView(product: $0) }
    }
}
