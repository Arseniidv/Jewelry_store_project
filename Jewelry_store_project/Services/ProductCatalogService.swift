import Foundation

class ProductCatalogService: ProductCatalogServing {

    static let shared = ProductCatalogService()

    var allProducts: [Product] = Product.catalog

    var allCollections: [String] {
        Array(Set(allProducts.map { $0.collection }))
    }

    func filteredProducts(
        searchText: String,
        selectedTag: String?,
        filter: CatalogFilter
    ) -> [Product] {
        var result = allProducts

        if !searchText.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }

        if let selectedTag {
            result = result.filter { $0.tag == selectedTag }
        }

        if !filter.categories.isEmpty {
            result = result.filter { filter.categories.contains($0.category) }
        }
        if !filter.collections.isEmpty {
            result = result.filter { filter.collections.contains($0.collection) }
        }
        if let minPrice = filter.minimumPrice {
            result = result.filter { $0.price >= minPrice }
        }
        if let maxPrice = filter.maximumPrice {
            result = result.filter { $0.price <= maxPrice }
        }

        switch filter.sort {
        case .featured:
            break
        case .priceAscending:
            result.sort { $0.price < $1.price }
        case .priceDescending:
            result.sort { $0.price > $1.price }
        case .nameAscending:
            result.sort { $0.name.localizedCompare($1.name) == .orderedAscending }
        }

        return result
    }

    func fetchProducts(completion: @escaping ([Product]) -> Void) {
        completion([])
    }

    func product(forID catalogID: String) -> Product? {
        allProducts.first { $0.catalogID == catalogID }
    }
}
