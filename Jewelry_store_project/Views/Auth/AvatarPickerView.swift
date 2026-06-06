import SwiftUI

struct AvatarPickerView: View {
    @Binding var selected: String
    @Environment(\.dismiss) private var dismiss

    private let avatars = [
        "person.circle.fill",
        "person.crop.circle.fill",
        "person.fill",
        "person.circle",
        "person.crop.circle.badge.checkmark",
        "person.crop.circle.badge.plus",
        "person.crop.rectangle.stack.fill",
        "person.text.rectangle.fill",
        "person.fill.viewfinder",
        "person.and.background.dotted",
        "person.crop.artframe",
        "person.crop.circle.dashed",
    ]

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 4)

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(avatars, id: \.self) { avatar in
                        Button {
                            selected = avatar
                            dismiss()
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(selected == avatar ? AppTheme.accentDark : AppTheme.surfaceMuted)
                                    .frame(width: 72, height: 72)

                                Image(systemName: avatar)
                                    .font(.title2)
                                    .foregroundStyle(selected == avatar ? AppTheme.onAccent : AppTheme.primaryText)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(20)
            }
            .appScreenBackground()
            .navigationTitle("Choose Avatar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
