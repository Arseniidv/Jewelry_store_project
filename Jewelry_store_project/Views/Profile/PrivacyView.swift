import SwiftUI
import LocalAuthentication

struct PrivacyView: View {
    @AppStorage("isBiometricAuthEnabled") private var isBiometricAuthEnabled = false
    @State private var showingBiometryError = false
    @State private var biometryErrorMessage = ""

    private var biometryType: String {
        let context = LAContext()
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) else {
            return "Face ID / Touch ID"
        }
        switch context.biometryType {
        case .faceID: return "Face ID"
        case .touchID: return "Touch ID"
        case .opticID: return "Optic ID"
        case .none: return "Face ID / Touch ID"
        @unknown default: return "Face ID / Touch ID"
        }
    }

    var body: some View {
        Form {
            Section {
                Toggle(isOn: Binding(
                    get: { isBiometricAuthEnabled },
                    set: { newValue in
                        if newValue {
                            authenticateUser { success in
                                isBiometricAuthEnabled = success
                            }
                        } else {
                            isBiometricAuthEnabled = false
                        }
                    }
                )) {
                    Label(biometryType, systemImage: biometryIcon)
                }
            } footer: {
                Text("Enable \(biometryType) to quickly and securely access your account.")
            }
        }
        .appScreenBackground()
        .navigationTitle("Приватность")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Biometry Error", isPresented: $showingBiometryError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(biometryErrorMessage)
        }
    }

    private var biometryIcon: String {
        let context = LAContext()
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) else {
            return "lock.shield"
        }
        switch context.biometryType {
        case .faceID: return "faceid"
        case .touchID: return "touchid"
        case .opticID: return "opticid"
        case .none: return "lock.shield"
        @unknown default: return "lock.shield"
        }
    }

    private func authenticateUser(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            biometryErrorMessage = error?.localizedDescription ?? "Biometry not available"
            showingBiometryError = true
            completion(false)
            return
        }

        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Авторизуйтесь для безопасного входа в приложение") { success, evalError in
            DispatchQueue.main.async {
                if success {
                    completion(true)
                } else {
                    isBiometricAuthEnabled = false
                    biometryErrorMessage = evalError?.localizedDescription ?? "Authentication failed"
                    showingBiometryError = true
                    completion(false)
                }
            }
        }
    }
}
