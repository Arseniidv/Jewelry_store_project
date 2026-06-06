import SwiftUI

private struct ProductCatalogKey: EnvironmentKey {
    static let defaultValue: ProductCatalogServing =
        ProductCatalogService.shared
}

extension EnvironmentValues {
    var productCatalog: ProductCatalogServing {
        get { self[ProductCatalogKey.self] }
        set { self[ProductCatalogKey.self] = newValue }
    }
}
