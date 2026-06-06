import SwiftUI

struct RootView: View {
    @Environment(AuthManager.self) private var authManager
    @AppStorage("theme") private var theme: ThemeOption = .system
    @AppStorage("fontSize") private var fontSize: FontSizeOption = .medium

    var body: some View {
        Group {
            if authManager.isAuthenticated {
                ContentView()
            } else {
                LoginView()
            }
        }
        .preferredColorScheme(theme.colorScheme)
        .dynamicTypeSize(fontSize.dynamicTypeBounds)
    }
}
