import Foundation

@Observable
final class CategoryDetailViewModel {
    private(set) var products: [Product] = []

    private let categoryType: CategoryType
    private let catalog: ProductCatalogServing

    init(categoryType: CategoryType, catalog: ProductCatalogServing) {
        self.categoryType = categoryType
        self.catalog = catalog
        self.products = filteredProducts()
    }

    private func filteredProducts() -> [Product] {
        guard let productCategory = categoryType.productCategory else {
            return []
        }
        return catalog.allProducts.filter { $0.category == productCategory }
    }
}
