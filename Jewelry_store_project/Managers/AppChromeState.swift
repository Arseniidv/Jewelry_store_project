import Foundation
import Observation

@Observable
final class AppChromeState {
    private var forceHideCount = 0
    var isBottomBarHidden: Bool {
        forceHideCount > 0
    }
    func setBottomBarHidden(_ hidden: Bool) {
        if hidden {
            forceHideCount += 1
        } else {
            forceHideCount = max(0, forceHideCount - 1)
        }
    }
}
