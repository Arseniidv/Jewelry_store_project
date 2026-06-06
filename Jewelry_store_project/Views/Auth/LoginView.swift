import SwiftUI

struct LoginView: View {
    @Environment(AuthManager.self) private var authManager
    @State private var email = ""
    @State private var password = ""
    @State private var showRegister = false
    @State private var errorMessage: String?
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    Spacer().frame(height: 40)

                    Image(systemName: "bag.circle.fill")
                        .font(.system(size: 72))
                        .foregroundStyle(AppTheme.accentDark)

                    Text("Jewelry Store")
                        .font(.largeTitle.bold())
                        .foregroundStyle(AppTheme.primaryText)

                    Text("Sign in to your account")
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.secondaryText)

                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Email").foregroundStyle(AppTheme.secondaryText).font(.subheadline)
                            TextField("anna@example.com", text: $email)
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .padding()
                                .background(AppTheme.surfaceMuted)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Password").foregroundStyle(AppTheme.secondaryText).font(.subheadline)
                            SecureField("Your password", text: $password)
                                .padding()
                                .background(AppTheme.surfaceMuted)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }

                    if let errorMessage {
                        Text(errorMessage)
                            .font(.callout)
                            .foregroundStyle(.red)
                    }

                    Button {
                        login()
                    } label: {
                        Group {
                            if isLoading {
                                ProgressView().tint(AppTheme.onAccent)
                            } else {
                                Text("Sign In")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(AppTheme.accentDark)
                        .foregroundStyle(AppTheme.onAccent)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .disabled(isLoading)

                    Button {
                        showRegister = true
                    } label: {
                        Text("Don't have an account? **Register**")
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.primaryText)
                    }
                }
                .padding(.horizontal, 24)
            }
            .appScreenBackground()
            .navigationDestination(isPresented: $showRegister) {
                RegisterView()
            }
        }
    }

    private func login() {
        isLoading = true
        errorMessage = nil
        do {
            try authManager.login(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

#Preview {
    LoginView()
        .environment(AuthManager())
}
