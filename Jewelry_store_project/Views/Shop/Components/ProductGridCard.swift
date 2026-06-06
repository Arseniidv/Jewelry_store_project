import SwiftUI

struct ProductGridCard: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .topTrailing) {
                Image(product.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .aspectRatio(1, contentMode: .fill)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                FavoriteHeartButton(
                    product: product,
                    iconFont: .caption,
                    foregroundWhenOff: .secondary
                )
                .padding(2)
            }

            Text(product.name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(2)
                .foregroundStyle(AppTheme.primaryText)

            Text(product.formattedPrice)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(AppTheme.primaryText)
        }
    }
}
