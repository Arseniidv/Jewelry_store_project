import Foundation
import Combine

final class PasswordRecoveryViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var isLoading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String? = nil

    // Navigation callback - app can inject a real router
    var onBack: (() -> Void)?

    var isEmailValid: Bool {
        // Simple validation - modify to reuse project's validation utilities when available
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && email.contains("@")
    }

    func sendRecovery() async {
        guard isEmailValid, !isLoading else { return }
        isLoading = true
        alertMessage = nil

        do {
            // Replace with real network call
            try await Task.sleep(nanoseconds: 800_000_000) // 0.8s

            // Simulate success
            await MainActor.run {
                self.isLoading = false
                self.alertMessage = "Письмо с инструкциями отправлено на \(self.email)"
                self.showAlert = true
            }
        } catch {
            await MainActor.run {
                self.isLoading = false
                self.alertMessage = "Не удалось отправить. Попробуйте позже."
                self.showAlert = true
            }
        }
    }
}
