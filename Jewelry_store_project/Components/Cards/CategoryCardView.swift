import SwiftUI

struct CategoryCardView: View {
    let image: String
    let title: String

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(image)
                .resizable()
                .scaledToFill()
                .frame(width: 160, height: 200)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 16))

            LinearGradient(
                colors: [.clear, .black.opacity(0.55)],
                startPoint: .top,
                endPoint: .bottom
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 14)
                .padding(.bottom, 14)
        }
        .frame(width: 160, height: 200)
    }
}

#Preview {
    ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 12) {
            CategoryCardView(image: "BlueRock", title: "Rings")
            CategoryCardView(image: "PinkRock", title: "Earrings")
            CategoryCardView(image: "RedRock", title: "Bracelets")
            CategoryCardView(image: "Emerald", title: "Necklaces")
        }
        .padding()
    }
}
