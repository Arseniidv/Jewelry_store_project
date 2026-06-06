import SwiftUI

struct BottomNavigationView: View {
    @Binding var selectedTab: MainTab

    private let barColor = AppTheme.accentDark

    var body: some View {
        HStack {
            ForEach(MainTab.allCases, id: \.self) { tab in
                Button {
                    selectedTab = tab
                } label: {
                    tabIcon(for: tab, isSelected: selectedTab == tab)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 18)
        .background(barColor)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.18), radius: 16, y: 6)
        .padding(.horizontal, 20)
    }

    private func tabIcon(for tab: MainTab, isSelected: Bool) -> some View {
        Image(systemName: tab.iconName)
            .font(.system(size: 22, weight: .regular))
            .foregroundStyle(isSelected ? AppTheme.onAccent : AppTheme.onAccent.opacity(0.45))
            .frame(maxWidth: .infinity)
            .frame(height: 28)
    }
}

#Preview {
    @Previewable @State var tab: MainTab = .home
    BottomNavigationView(selectedTab: $tab)
        .padding(.vertical)
        .background(Color.gray.opacity(0.2))
}
