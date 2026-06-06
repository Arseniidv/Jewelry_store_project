import Foundation

struct Product: Identifiable, Hashable {
    let catalogID: String
    let name: String
    let collection: String
    let price: Double
    let imageName: String
    let description: String
    let category: ProductCategory
    let tag: String
    let rating: Double = 4.9
    let reviewCount: Int = 128

    var id: String { catalogID }

    var formattedPrice: String {
        let raw = UserDefaults.standard.string(forKey: "currency") ?? "usd"
        let currency = CurrencyOption(rawValue: raw) ?? .usd
        return currency.format(price)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(catalogID)
    }

    static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.catalogID == rhs.catalogID
    }
}

extension Product {
    static let catalog: [Product] = [
        Product(
            catalogID: "diamond-solitaire",
            name: "Sapphire",
            collection: "Summer Vibes",
            price: 2499,
            imageName: "BlueRock",
            description: "Elegant diamond solitaire ring featuring a brilliant cut diamond set in 18k white gold.",
            category: .rings,
            tag: "Amethysts"
        ),
        Product(
            catalogID: "pink-sapphire-earrings",
            name: "Kunzite",
            collection: "Street Style",
            price: 1299,
            imageName: "PinkRock",
            description: "Stunning pink sapphire earrings with delicate gold setting.",
            category: .earrings,
            tag: "Apatites"
        ),
        Product(
            catalogID: "gold-chain-bracelet",
            name: "Gold Chain Bracelet",
            collection: "Street Style",
            price: 899,
            imageName: "RedRock",
            description: "Minimalist 18k gold chain bracelet.",
            category: .bracelets,
            tag: "Granites"
        ),
        Product(
            catalogID: "emerald-pendant",
            name: "Emerald Pendant",
            collection: "Summer Vibes",
            price: 1899,
            imageName: "Emerald",
            description: "Emerald pendant necklace on a fine gold chain.",
            category: .necklaces,
            tag: "Cobalt Spinel"
        ),
        Product(
            catalogID: "ruby-halo-ring",
            name: "Ruby Halo Ring",
            collection: "Evening Glow",
            price: 3199,
            imageName: "Zircon",
            description: "Ruby center stone with diamond halo in platinum.",
            category: .rings,
            tag: "Rubies"
        ),
        Product(
            catalogID: "pearl-drop-earrings",
            name: "Pearl Drop Earrings",
            collection: "Evening Glow",
            price: 749,
            imageName: "Aquamarine",
            description: "Classic pearl drops with 14k gold hooks.",
            category: .earrings,
            tag: "Peridots"
        )
    ]

    static var sampleProducts: [Product] { Product.catalog }
}
