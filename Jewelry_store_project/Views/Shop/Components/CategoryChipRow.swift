import SwiftUI

struct CategoryChipRow: View {
    @Binding var selectedTag: String?
    let tags: [String]

    private let activeColor = AppTheme.accentDark

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                Button {
                    selectedTag = nil
                } label: {
                    Text("All")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(selectedTag == nil ? AppTheme.onAccent : AppTheme.primaryText)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(selectedTag == nil ? activeColor : AppTheme.surfaceMuted)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)

                ForEach(tags, id: \.self) { tag in
                    Button {
                        selectedTag = tag
                    } label: {
                        Text(tag)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .lineLimit(1)
                            .foregroundStyle(selectedTag == tag ? AppTheme.onAccent : AppTheme.primaryText)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 10)
                            .background(selectedTag == tag ? activeColor : AppTheme.surfaceMuted)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
