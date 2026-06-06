import Foundation
import Observation

@Observable
final class CatalogViewModel {
    var isLoading = false
    var searchText = ""
    var selectedTag: String?
    var filter = CatalogFilter()
    var showFilterSheet = false

    private let catalogService: ProductCatalogServing

    init(catalogService: ProductCatalogServing = ProductCatalogService.shared) {
        self.catalogService = catalogService
    }

    var displayedProducts: [Product] {
        catalogService.filteredProducts(
            searchText: searchText,
            selectedTag: selectedTag,
            filter: filter
        )
    }

    var availableCollections: [String] {
        catalogService.allCollections
    }

    func applyFilter(_ draft: CatalogFilter) {
        filter = draft
        showFilterSheet = false
    }

    func resetFilter() {
        filter = CatalogFilter()
    }
}
