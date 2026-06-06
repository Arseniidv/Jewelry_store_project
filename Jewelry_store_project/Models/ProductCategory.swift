import Foundation

enum ProductCategory: String, CaseIterable, Identifiable, Hashable, Codable {
    case rings
    case necklaces
    case earrings
    case bracelets

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .rings: return "Rings"
        case .necklaces: return "Necklaces"
        case .earrings: return "Earrings"
        case .bracelets: return "Bracelets"
        }
    }
}

extension ProductCategory {
    static let catalogTags: [String] = [
        "Amethysts", "Apatites", "Granites", "Cobalt Spinel",
        "Peridots", "Rubies", "Spessartine", "Tanzanite",
        "Paraiba Tourmaline", "Tsavorite"
    ]
}
