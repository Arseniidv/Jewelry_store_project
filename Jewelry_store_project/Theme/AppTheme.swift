import SwiftUI

enum AppTheme {
    static let screenBackground = Color("AppBackground")
    static let primaryText = Color("AppPrimaryText")
    static let secondaryText = Color("AppSecondaryText")
    static let surfaceMuted = Color("AppSurface")
    static let accentDark = Color("AppAccent")
    static let onAccent = Color.white
}

extension View {
    func appScreenBackground() -> some View {
        scrollContentBackground(.hidden)
            .background(AppTheme.screenBackground.ignoresSafeArea())
    }
}
