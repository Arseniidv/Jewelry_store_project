import SwiftUI

struct ProductCardView: View {
    let image: String
    let title: String
    let material: String
    let price: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(image)
                .resizable()
                .scaledToFill()
                .frame(height: 180)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 16))

            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(AppTheme.primaryText)
                .lineLimit(2)

            Text(material)
                .font(.subheadline)
                .foregroundStyle(AppTheme.secondaryText)
                .lineLimit(1)

            Text(price)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(AppTheme.primaryText)
        }
    }
}

#Preview {
    ProductCardView(
        image: "BlueRock",
        title: "Blue Moon Diamond",
        material: "Gold",
        price: "1 299 US$"
    )
    .padding()
    .frame(width: 180)
}
