import SwiftUI

struct SectionHeaderView: View {
    let text: String
    let route: HomeSectionRoute?

    var body: some View {
        HStack {
            Text(text)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(AppTheme.primaryText)

            Spacer()

            if let route {
                NavigationLink(value: route) {
                    Image(systemName: "arrow.forward")
                        .foregroundStyle(AppTheme.primaryText)
                }
                .buttonStyle(.plain)
            }
        }
    }
}
