import SwiftUI
import LocalAuthentication

struct BiometricLockView: View {
    let biometricFailed: Bool
    let onRetry: () -> Void

    @State private var isAnimating = false

    private var biometryIcon: String {
        let context = LAContext()
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) else {
            return "lock.shield"
        }
        switch context.biometryType {
        case .faceID: return "faceid"
        case .touchID: return "touchid"
        default: return "lock.shield"
        }
    }

    var body: some View {
        ZStack {
            AppTheme.screenBackground.ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Image(systemName: "bag.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(AppTheme.accentDark)
                    .scaleEffect(isAnimating ? 1.05 : 0.95)

                Text("Jewelry Store")
                    .font(.title.bold())
                    .foregroundStyle(AppTheme.primaryText)

                Text("Authenticate to continue")
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.secondaryText)

                Spacer()

                if biometricFailed {
                    Button(action: onRetry) {
                        HStack(spacing: 12) {
                            Image(systemName: biometryIcon)
                                .font(.title2)
                            Text("Try Again")
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(AppTheme.onAccent)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 16)
                        .background(AppTheme.accentDark)
                        .clipShape(Capsule())
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .padding(.bottom, 60)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}
