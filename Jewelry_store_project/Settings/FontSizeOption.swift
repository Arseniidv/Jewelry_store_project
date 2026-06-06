import SwiftUI

enum FontSizeOption: String, CaseIterable, Identifiable {
    case small, medium, large
    var id: String { rawValue }
    var label: String {
        switch self {
        case .small: return "Small"
        case .medium: return "Medium"
        case .large: return "Large"
        }
    }
    var dynamicTypeBounds: ClosedRange<DynamicTypeSize> {
        switch self {
        case .small: return .xSmall ... .medium
        case .medium: return .xSmall ... .xxLarge
        case .large: return .xSmall ... .accessibility3
        }
    }
}
