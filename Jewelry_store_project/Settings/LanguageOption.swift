import Foundation

enum LanguageOption: String, CaseIterable, Identifiable {
    case english, russian
    var id: String { rawValue }
    var label: String {
        switch self {
        case .english: return "English"
        case .russian: return "Русский"
        }
    }
}
