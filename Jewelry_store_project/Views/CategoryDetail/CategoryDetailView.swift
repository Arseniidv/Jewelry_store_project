import SwiftUI

struct CategoryDetailView: View {
    let category: ServiceCategory
    @State private var viewModel: CategoryDetailViewModel

    init(category: ServiceCategory) {
        self.category = category
        self._viewModel = State(initialValue: CategoryDetailViewModel(
            categoryType: category.type,
            catalog: ProductCatalogService.shared
        ))
    }

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            if viewModel.products.isEmpty {
                ContentUnavailableView(
                    "No products yet",
                    systemImage: "shippingbox",
                    description: Text("Products in this category are coming soon.")
                )
                .frame(maxWidth: .infinity)
                .padding(.top, 60)
            } else {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.products) { product in
                        ProductNavigationLink(product: product) {
                            ProductCardView(
                                image: product.imageName,
                                title: product.name,
                                material: product.collection,
                                price: product.formattedPrice
                            )
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
        }
        .appScreenBackground()
        .navigationTitle(category.nameEn)
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        CategoryDetailView(category: .all[0])
    }
    .environment(FavoritesStore())
    .environment(AppChromeState())
}
