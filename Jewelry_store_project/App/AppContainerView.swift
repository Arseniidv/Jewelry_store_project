import SwiftUI
import SwiftData
import LocalAuthentication
import UserNotifications

struct AppContainerView: View {
    @Environment(AuthManager.self) private var authManager
    @Environment(NotificationService.self) private var notificationService
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.modelContext) private var modelContext
    @AppStorage("isBiometricAuthEnabled") private var isBiometricAuthEnabled = false

    @State private var isAppUnlocked = false
    @State private var isSessionReady = false
    @State private var lastBackgroundDate: Date?
    @State private var biometricFailed = false
    @State private var hasAutoAttempted = false

    private let backgroundTimeout: TimeInterval = 15

    var body: some View {
        ZStack {
            if isSessionReady {
                RootView()
            }

            if isSessionReady && isBiometricAuthEnabled && authManager.isAuthenticated && !isAppUnlocked {
                BiometricLockView(
                    biometricFailed: biometricFailed,
                    onRetry: authenticate
                )
                .transition(.opacity)
                .onAppear {
                    guard !hasAutoAttempted else { return }
                    hasAutoAttempted = true
                    authenticate()
                }
            }
        }
        .animation(.easeInOut(duration: 0.4), value: isAppUnlocked)
        .onAppear {
            authManager.configure(modelContext: modelContext)
            authManager.restoreSession()
            notificationService.configure(modelContext: modelContext)
            UNUserNotificationCenter.current().delegate = notificationService
            notificationService.requestAuthorization()
            isSessionReady = true
        }
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .background:
                lastBackgroundDate = Date()
                hasAutoAttempted = false
            case .active:
                guard let lastDate = lastBackgroundDate else { return }
                if Date().timeIntervalSince(lastDate) > backgroundTimeout {
                    isAppUnlocked = false
                    biometricFailed = false
                    hasAutoAttempted = false
                }
                lastBackgroundDate = nil
            default:
                break
            }
        }
    }

    private func authenticate() {
        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            isAppUnlocked = true
            return
        }

        biometricFailed = false

        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Авторизуйтесь для входа в приложение") { success, evalError in
            DispatchQueue.main.async {
                if success {
                    withAnimation {
                        isAppUnlocked = true
                        biometricFailed = false
                    }
                } else {
                    biometricFailed = true
                }
            }
        }
    }
}
