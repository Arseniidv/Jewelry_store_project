import Foundation
import Observation

@Observable
final class FavoritesStore {
    private(set) var favoriteIDs: Set<String> = []
    func isFavorite(_ product: Product) -> Bool {
        favoriteIDs.contains(product.catalogID)
    }
    func toggle(_ product: Product) {
        if favoriteIDs.contains(product.catalogID) {
            favoriteIDs.remove(product.catalogID)
        } else {
            favoriteIDs.insert(product.catalogID)
        }
    }
    var favoriteProducts: [Product] {
        Product.sampleProducts.filter {
            favoriteIDs.contains($0.catalogID)
        }
    }
}
