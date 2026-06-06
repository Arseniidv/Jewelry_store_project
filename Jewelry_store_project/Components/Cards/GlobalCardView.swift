import SwiftUI

struct GlobalCardView: View {
    let product: Product
    var title: String?
    var subtitle: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                Image(product.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 280, height: 200)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                FavoriteHeartButton(product: product)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title ?? product.collection)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(AppTheme.primaryText)
                    .lineLimit(1)

                Text(subtitle ?? product.name)
                    .font(.system(size: 14))
                    .foregroundStyle(AppTheme.secondaryText)
                    .lineLimit(1)
            }
            .padding(.top, 12)
            .padding(.horizontal, 4)
        }
        .frame(width: 280)
    }
}
