import Foundation
import SwiftData
import CryptoKit
import Observation

private let sessionUserIDKey = "com.jewelrystore.session.userID"

@Observable
final class AuthManager {
    private(set) var currentUser: StoredUser?
    private var modelContext: ModelContext?

    var isAuthenticated: Bool { currentUser != nil }

    func configure(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func restoreSession() {
        guard let userID = UserDefaults.standard.string(forKey: sessionUserIDKey) else { return }
        guard let modelContext else { return }
        let predicate = #Predicate<StoredUser> { $0.id == userID }
        let descriptor = FetchDescriptor(predicate: predicate)
        if let user = try? modelContext.fetch(descriptor).first {
            currentUser = user
        }
    }

    func register(email: String, password: String, name: String) throws {
        guard let modelContext else { throw AuthError.noContext }
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else { throw AuthError.invalidEmail }
        guard !password.trimmingCharacters(in: .whitespaces).isEmpty else { throw AuthError.invalidPassword }
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else { throw AuthError.invalidName }

        let email = email.lowercased().trimmingCharacters(in: .whitespaces)
        let emailPredicate = #Predicate<StoredUser> { $0.email == email }
        let emailDescriptor = FetchDescriptor(predicate: emailPredicate)
        let existing = try modelContext.fetch(emailDescriptor)
        guard existing.isEmpty else { throw AuthError.emailTaken }

        let hash = hashPassword(password)
        let user = StoredUser(email: email, passwordHash: hash, name: name.trimmingCharacters(in: .whitespaces))
        modelContext.insert(user)
        try modelContext.save()

        currentUser = user
        UserDefaults.standard.set(user.id, forKey: sessionUserIDKey)
    }

    func login(email: String, password: String) throws {
        guard let modelContext else { throw AuthError.noContext }
        let email = email.lowercased().trimmingCharacters(in: .whitespaces)
        guard !email.isEmpty else { throw AuthError.invalidEmail }
        guard !password.isEmpty else { throw AuthError.invalidPassword }

        let predicate = #Predicate<StoredUser> { $0.email == email }
        let descriptor = FetchDescriptor(predicate: predicate)
        let results = try modelContext.fetch(descriptor)

        guard let user = results.first else { throw AuthError.invalidCredentials }
        guard user.passwordHash == hashPassword(password) else { throw AuthError.invalidCredentials }

        currentUser = user
        UserDefaults.standard.set(user.id, forKey: sessionUserIDKey)
    }

    func logout() {
        currentUser = nil
        UserDefaults.standard.removeObject(forKey: sessionUserIDKey)
    }

    func updateAvatar(_ avatarName: String) {
        currentUser?.avatarName = avatarName
        try? modelContext?.save()
    }

    func updateName(_ name: String) {
        currentUser?.name = name
        try? modelContext?.save()
    }

    private func hashPassword(_ password: String) -> String {
        let data = Data(password.utf8)
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
}

enum AuthError: LocalizedError {
    case noContext
    case invalidEmail
    case invalidPassword
    case invalidName
    case emailTaken
    case invalidCredentials

    var errorDescription: String? {
        switch self {
        case .noContext: return "Internal error"
        case .invalidEmail: return "Please enter a valid email"
        case .invalidPassword: return "Please enter a password"
        case .invalidName: return "Please enter your name"
        case .emailTaken: return "This email is already registered"
        case .invalidCredentials: return "Invalid email or password"
        }
    }
}
