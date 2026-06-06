import SwiftUI

struct ShopView: View {
    @State private var viewModel = CatalogViewModel()
    @State private var filterDraft = CatalogFilter()

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                CatalogHeaderView(
                    onFilterTap: { viewModel.showFilterSheet = true },
                    filterIsActive: viewModel.filter.isActive
                )

                CatalogSearchBar(text: $viewModel.searchText)

                CategoryChipRow(selectedTag: $viewModel.selectedTag, tags: ProductCategory.catalogTags)

                if viewModel.displayedProducts.isEmpty {
                    ContentUnavailableView(
                        "No products found",
                        systemImage: "bag",
                        description: Text("Try another category or adjust your filters.")
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.top, 40)
                } else {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.displayedProducts) { product in
                            ProductNavigationLink(product: product) {
                                ProductGridCard(product: product)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .appScreenBackground()
        .navigationTitle("Catalog")
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(for: Product.self) { product in
            ProductDetailView(product: product)
        }
        .sheet(isPresented: $viewModel.showFilterSheet) {
            CatalogFilterView(
                collections: viewModel.availableCollections,
                draft: $filterDraft,
                onApply: {
                    viewModel.applyFilter(filterDraft)
                },
                onReset: {
                    viewModel.resetFilter()
                    filterDraft = CatalogFilter()
                    viewModel.showFilterSheet = false
                }
            )
            .onAppear {
                filterDraft = viewModel.filter
            }
        }
    }
}

#Preview {
    NavigationStack {
        ShopView()
    }
    .environment(AppChromeState())
}
