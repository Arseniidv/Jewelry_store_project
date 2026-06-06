import SwiftUI

/// Full-width card for section list screens (arrow navigation).
struct ProductListCardView: View {
    let product: Product
    let subtitle: String
    let showsFavorite: Bool

    var body: some View {
        GeometryReader { geometry in
            let imageHeight = geometry.size.height * 0.72

            VStack(alignment: .leading, spacing: 10) {
                ZStack(alignment: .topTrailing) {
                    Image(product.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: imageHeight)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 16))

                    if showsFavorite {
                        Image(systemName: "heart")
                            .font(.title3)
                            .foregroundStyle(.white)
                            .padding(10)
                            .background(.ultraThinMaterial, in: Circle())
                            .padding(12)
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(product.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .foregroundStyle(AppTheme.primaryText)

                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.secondaryText)
                        .lineLimit(1)
                }
                .padding(.horizontal, 4)

                Spacer(minLength: 0)
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .topLeading)
        }
    }
}
