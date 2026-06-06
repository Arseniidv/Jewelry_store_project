import Foundation

enum CategoryType: String, Codable {
    case rings
    case earrings
    case necklaces
    case bracelets
    case brooches
    case custom

    var productCategory: ProductCategory? {
        switch self {
        case .rings: return .rings
        case .earrings: return .earrings
        case .necklaces: return .necklaces
        case .bracelets: return .bracelets
        case .brooches: return nil
        case .custom: return nil
        }
    }
}

struct ServiceCategory: Identifiable, Hashable, Codable {
    let id: String
    let nameEn: String
    let imageName: String
    let type: CategoryType
}

extension ServiceCategory {
    static let all: [ServiceCategory] = [
        ServiceCategory(id: "rings", nameEn: "Rings", imageName: "BlueRock", type: .rings),
        ServiceCategory(id: "brooches", nameEn: "Brooches", imageName: "PinkRock", type: .brooches),
        ServiceCategory(id: "custom", nameEn: "Custom Items", imageName: "RedRock", type: .custom),
        ServiceCategory(id: "necklaces", nameEn: "Necklaces & Pendants", imageName: "Emerald", type: .necklaces),
        ServiceCategory(id: "earrings", nameEn: "Earrings", imageName: "Aquamarine", type: .earrings),
        ServiceCategory(id: "bracelets", nameEn: "Bracelets", imageName: "Zircon", type: .bracelets),
    ]
}
