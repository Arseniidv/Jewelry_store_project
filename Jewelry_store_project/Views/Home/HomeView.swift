import SwiftUI

struct HomeView: View {

    @State private var searchText: String = ""
    @Binding var selectedTab: MainTab

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {

                PageHeader(selectedTab: $selectedTab)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                SearchBar(text: $searchText)
                    .padding(.horizontal, 20)

                VStack(alignment: .leading, spacing: 24) {

                    SectionHeaderView(text: "Popular Collections", route: .popularCollections)
                        .padding(.horizontal, 4)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(Product.sampleProducts.prefix(4)) { product in
                                ProductNavigationLink(product: product) {
                                    GlobalCardView(
                                        product: product,
                                        title: product.name,
                                        subtitle: product.collection
                                    )
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 4)

                    SectionHeaderView(text: "Popular Category", route: .popularCategory)
                        .padding(.horizontal, 4)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(Product.sampleProducts.prefix(3)) { product in
                                ProductNavigationLink(product: product) {
                                    ProductCardView(
                                        image: product.imageName,
                                        title: product.name,
                                        material: product.category.displayName,
                                        price: product.formattedPrice
                                    )
                                    .frame(width: 240)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 4)

                    SectionHeaderView(text: "Our Services", route: nil)
                        .padding(.horizontal, 4)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(ServiceCategory.all) { category in
                                ServiceCardView(category: category)
                            }
                        }
                    }
                    .padding(.horizontal, 4)
                }
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 100)
        }
        .appScreenBackground()
    }
}

#Preview {
    HomeView(selectedTab: .constant(.home))
        .environment(FavoritesStore())
        .environment(AppChromeState())
        .environment(AuthManager())
        .environment(\.productCatalog, ProductCatalogService.shared)
        .environment(AppNotificationManager())
}
