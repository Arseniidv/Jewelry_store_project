import SwiftUI

struct ServiceCardView: View {
    let category: ServiceCategory

    var body: some View {
        NavigationLink(value: category) {
            ZStack(alignment: .bottomLeading) {
                Image(category.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 160, height: 160)
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                LinearGradient(
                    colors: [.clear, .black.opacity(0.6)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))

                Text(category.nameEn)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.bottom, 12)
            }
            .frame(width: 160, height: 160)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 16) {
            ForEach(ServiceCategory.all) { category in
                ServiceCardView(category: category)
            }
        }
        .padding()
    }
}
