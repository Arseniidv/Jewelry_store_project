import Foundation

enum MainTab: CaseIterable, Hashable {
    case home
    case shop
    case favorites
    case profile

    var iconName: String {
        switch self {
        case .home: return "house"
        case .shop: return "bag"
        case .favorites: return "heart"
        case .profile: return "person"
        }
    }


    var title: String {
        switch self {
        case .home: return "Home"
        case .shop: return "Shop"
        case .favorites: return "Favorites"
        case .profile: return "Profile"
        }
    }
}
