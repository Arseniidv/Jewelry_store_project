import Foundation
import SwiftData

@Model
final class StoredUser {
    @Attribute(.unique) var id: String
    var email: String
    var passwordHash: String
    var name: String
    var avatarName: String
    var createdAt: Date

    init(
        id: String = UUID().uuidString,
        email: String,
        passwordHash: String,
        name: String,
        avatarName: String = "person.circle.fill",
        createdAt: Date = .now
    ) {
        self.id = id
        self.email = email
        self.passwordHash = passwordHash
        self.name = name
        self.avatarName = avatarName
        self.createdAt = createdAt
    }
}
