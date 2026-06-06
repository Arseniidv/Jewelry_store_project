import Foundation

/// Abstraction for loading and filtering products — swap mock for API later.
protocol ProductCatalogServing {
    var allProducts: [Product] { get }
    var allCollections: [String] { get }

    func fetchProducts(completion: @escaping ([Product]) -> Void)

    func filteredProducts(
        searchText: String,
        selectedTag: String?,
        filter: CatalogFilter
    ) -> [Product]

    func product(forID catalogID: String) -> Product?
}

extension ProductCatalogServing {
    func products(for route: HomeSectionRoute) -> [Product] {
        switch route {
        case .popularCollections, .popularCategory:
            return allProducts
        }
    }
}
