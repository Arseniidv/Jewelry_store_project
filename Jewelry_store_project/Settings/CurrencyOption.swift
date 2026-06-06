import Foundation

enum CurrencyOption: String, CaseIterable, Identifiable {
    case usd, eur, rub
    var id: String { rawValue }
    var label: String {
        switch self {
        case .usd: return "USD ($)"
        case .eur: return "EUR (€)"
        case .rub: return "RUB (₽)"
        }
    }
    var currencyCode: String {
        switch self {
        case .usd: return "USD"
        case .eur: return "EUR"
        case .rub: return "RUB"
        }
    }
    func format(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "\(Int(value))"
    }
}
