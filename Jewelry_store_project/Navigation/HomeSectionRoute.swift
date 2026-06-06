import Foundation

/// Routes opened from the section header arrow (→), not from individual cards.
enum HomeSectionRoute: Hashable {
    case popularCollections
    case popularCategory

    var title: String {
        switch self {
        case .popularCollections: return "Popular Collections"
        case .popularCategory: return "Popular Category"
        }
    }

    func products(catalog: ProductCatalogServing = ProductCatalogService.shared) -> [Product] {
        catalog.products(for: self)
    }
}
