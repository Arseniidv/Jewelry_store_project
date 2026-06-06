import SwiftUI

/// Wraps any card label and navigates directly to product detail (same path as Popular Category).
struct ProductNavigationLink<Label: View>: View {
    let product: Product
    @ViewBuilder let label: () -> Label

    var body: some View {
        NavigationLink(value: product) {
            label()
        }
        .buttonStyle(PlainButtonStyle())
    }
}
