import SwiftUI

struct ProductDetailView: View {
    let product: Product

    @State private var selectedSize: Int = 7
    @State private var quantity: Int = 1

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    Image(product.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 340)
                        .clipped()

                    FavoriteHeartButton(
                        product: product,
                        iconFont: .title2,
                        foregroundWhenOff: .white
                    )
                }

                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Image(systemName: "star.fill").foregroundStyle(.yellow)
                        Text("4.9")
                            .foregroundStyle(AppTheme.primaryText)
                        Text("(128 reviews)")
                            .foregroundStyle(AppTheme.secondaryText)
                    }
                    .font(.subheadline)

                    Text(product.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(AppTheme.primaryText)

                    Text(product.collection)
                        .foregroundStyle(AppTheme.secondaryText)

                    Text(product.formattedPrice)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppTheme.primaryText)

                    Divider()

                    Text("Description")
                        .font(.headline)
                        .foregroundStyle(AppTheme.primaryText)
                    Text(product.description)
                        .foregroundStyle(AppTheme.secondaryText)
                        .lineSpacing(4)

                    if product.category == .rings {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Ring Size")
                                .font(.headline)
                                .foregroundStyle(AppTheme.primaryText)
                            HStack(spacing: 12) {
                                ForEach([5, 6, 7, 8, 9], id: \.self) { size in
                                    Button {
                                        selectedSize = size
                                    } label: {
                                        Text("\(size)")
                                            .frame(width: 44, height: 44)
                                            .background(selectedSize == size ? AppTheme.accentDark : AppTheme.surfaceMuted)
                                            .foregroundStyle(selectedSize == size ? AppTheme.onAccent : AppTheme.primaryText)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                    }
                                }
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Quantity")
                            .font(.headline)
                            .foregroundStyle(AppTheme.primaryText)
                        HStack {
                            Button("-") { if quantity > 1 { quantity -= 1 } }
                                .frame(width: 44, height: 44)
                                .background(AppTheme.surfaceMuted)
                                .foregroundStyle(AppTheme.primaryText)
                                .clipShape(Circle())

                            Text("\(quantity)")
                                .font(.title3)
                                .foregroundStyle(AppTheme.primaryText)
                                .frame(width: 40)

                            Button("+") { quantity += 1 }
                                .frame(width: 44, height: 44)
                                .background(AppTheme.surfaceMuted)
                                .foregroundStyle(AppTheme.primaryText)
                                .clipShape(Circle())
                        }
                    }

                    Button {
                    } label: {
                        Text("Add to Cart")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(AppTheme.onAccent)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(AppTheme.accentDark)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .padding(.top, 20)
                }
                .padding(20)
                .padding(.bottom, 24)
            }
        }
        .appScreenBackground()
        .navigationTitle("Product Details")
        .navigationBarTitleDisplayMode(.inline)
        .hidesBottomBarOnAppear()
    }
}
