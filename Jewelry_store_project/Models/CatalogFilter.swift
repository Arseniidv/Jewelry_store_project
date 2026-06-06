import Foundation

enum ProductSortOption: String, CaseIterable, Identifiable {
    case featured
    case priceAscending
    case priceDescending
    case nameAscending

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .featured: return "Featured"
        case .priceAscending: return "Price: Low to High"
        case .priceDescending: return "Price: High to Low"
        case .nameAscending: return "Name: A–Z"
        }
    }
}

/// Advanced filter parameters from the filter button.
struct CatalogFilter: Equatable {
    var sort: ProductSortOption = .featured
    var categories: Set<ProductCategory> = []
    var collections: Set<String> = []
    var minimumPrice: Double?
    var maximumPrice: Double?

    var isActive: Bool {
        sort != .featured
            || !categories.isEmpty
            || !collections.isEmpty
            || minimumPrice != nil
            || maximumPrice != nil
    }
}
