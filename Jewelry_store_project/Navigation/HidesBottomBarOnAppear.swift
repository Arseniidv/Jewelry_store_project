import SwiftUI

/// Hides the custom bottom navigation bar while this screen is visible.
struct HidesBottomBarOnAppear: ViewModifier {
    @Environment(AppChromeState.self) private var chrome

    func body(content: Content) -> some View {
        content
            .onAppear { chrome.setBottomBarHidden(true) }
            .onDisappear { chrome.setBottomBarHidden(false) }
    }
}

extension View {
    func hidesBottomBarOnAppear() -> some View {
        modifier(HidesBottomBarOnAppear())
    }
}
