import SwiftUI

struct CatalogSearchBar: View {
    @Binding var text: String
    var onSearch: () -> Void = {}

    private let barColor = AppTheme.accentDark

    var body: some View {
        HStack(spacing: 12) {
            TextField("Поиск...", text: $text)
                .foregroundStyle(AppTheme.primaryText)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .submitLabel(.search)
                .onSubmit(onSearch)

            Button(action: onSearch) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(barColor)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(.leading, 16)
        .padding(.trailing, 8)
        .padding(.vertical, 8)
        .background(AppTheme.surfaceMuted)
        .clipShape(Capsule())
    }
}
