import SwiftUI

struct RegisterView: View {
    @Environment(AuthManager.self) private var authManager
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var selectedAvatar = "person.circle.fill"
    @State private var showAvatarPicker = false
    @State private var errorMessage: String?
    @State private var isLoading = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Spacer().frame(height: 20)

                Button {
                    showAvatarPicker = true
                } label: {
                    ZStack {
                        Circle()
                            .fill(AppTheme.surfaceMuted)
                            .frame(width: 100, height: 100)

                        Image(systemName: selectedAvatar)
                            .font(.system(size: 42))
                            .foregroundStyle(AppTheme.accentDark)
                    }
                }

                Text("Choose avatar")
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.secondaryText)

                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Name").foregroundStyle(AppTheme.secondaryText).font(.subheadline)
                        TextField("Anna Ivanova", text: $name)
                            .textContentType(.name)
                            .padding()
                            .background(AppTheme.surfaceMuted)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

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

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Confirm password").foregroundStyle(AppTheme.secondaryText).font(.subheadline)
                        SecureField("Repeat password", text: $confirmPassword)
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
                    register()
                } label: {
                    Group {
                        if isLoading {
                            ProgressView().tint(AppTheme.onAccent)
                        } else {
                            Text("Create Account")
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
            }
            .padding(.horizontal, 24)
        }
        .appScreenBackground()
        .navigationTitle("Register")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAvatarPicker) {
            AvatarPickerView(selected: $selectedAvatar)
        }
    }

    private func register() {
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }
        isLoading = true
        errorMessage = nil
        do {
            try authManager.register(email: email, password: password, name: name)
            if authManager.isAuthenticated {
                authManager.updateAvatar(selectedAvatar)
                dismiss()
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

#Preview {
    NavigationStack {
        RegisterView()
            .environment(AuthManager())
    }
}
