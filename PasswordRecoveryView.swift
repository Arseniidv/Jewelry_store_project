import SwiftUI

// Polished Password Recovery screen with MVVM-friendly API.
// Self-contained view to be dropped into an existing SwiftUI app.

struct PasswordRecoveryView: View {
    @StateObject var viewModel = PasswordRecoveryViewModel()

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                header
                    .frame(height: min(geo.size.height * 0.30, 260))

                formContainer
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGroupedBackground))
                    .edgesIgnoringSafeArea(.bottom)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(Color(.systemBackground))
            .ignoresSafeArea(edges: .top)
        }
    }

    private var header: some View {
        ZStack(alignment: .topLeading) {
            // Brand background with a soft curve at the bottom
            GeometryReader { g in
                BrandColor
                    .overlay(
                        CurvedTopShape(curveHeightRatio: 0.18)
                            .fill(Color(.systemBackground))
                            .offset(y: g.size.height * 0.48)
                    )
                    .clipShape(Rectangle())
            }

            VStack(spacing: 8) {
                spacerForNotch

                // Logo
                Text("LOOTIK")
                    .font(.system(size: 36, weight: .regular, design: .serif))
                    .foregroundColor(.white)
                    .tracking(3)

                Text("ювелирный дом")
                    .font(.subheadline)
                    .foregroundColor(Color.white.opacity(0.9))
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 8)

            // Back button placeholder (use existing nav in app)
            Button(action: { viewModel.onBack?() }) {
                HStack(spacing: 8) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Назад")
                        .font(.subheadline)
                }
                .foregroundColor(.white)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color.white.opacity(0.12))
                .clipShape(Capsule())
            }
            .padding(.leading, 16)
            .padding(.top, 16)
        }
    }

    private var formContainer: some View {
        VStack(spacing: 16) {
            // Title and description
            VStack(spacing: 8) {
                Text("Восстановление пароля")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)

                Text("Введите email — мы отправим ссылку для сброса пароля")
                    .font(.subheadline)
                    .foregroundColor(Color.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
            .padding(.top, 8)

            // Form fields
            VStack(spacing: 12) {
                FloatingLabelInput(label: "Электронная почта", text: $viewModel.email, placeholder: "name@example.com", keyboard: .emailAddress)
            }
            .padding(.horizontal, 20)
            .padding(.top, 4)

            // Action
            VStack(spacing: 8) {
                Button(action: {
                    Task { await viewModel.sendRecovery() }
                }) {
                    HStack {
                        Spacer()
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(height: 20)
                        } else {
                            Text("ОТПРАВИТЬ ССЫЛКУ")
                                .fontWeight(.semibold)
                        }
                        Spacer()
                    }
                    .frame(height: 52)
                    .background(PrimaryButtonBackground())
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
                }
                .disabled(!viewModel.isEmailValid || viewModel.isLoading)
                .padding(.horizontal, 20)

                Spacer(minLength: 24)
            }
            .padding(.bottom, 24)
        }
        .padding(.top, 12)
    }

    private var spacerForNotch: some View {
        // Keep safe area spacing consistent across devices
        Color.clear.frame(height: 8)
    }

    // Reusable brand color (replace with project's token where available)
    private var BrandColor: Color { Color(hex: "EE6B4F") }
}

// MARK: - Supporting Views

private struct PrimaryButtonBackground: View {
    var body: some View {
        LinearGradient(colors: [Color(hex: "EE6B4F"), Color(hex: "E98A72")], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

private struct FloatingLabelInput: View {
    let label: String
    @Binding var text: String
    var placeholder: String = ""
    var keyboard: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label.uppercased())
                .font(.caption2)
                .foregroundColor(Color.secondary)

            TextField(placeholder, text: $text)
                .keyboardType(keyboard)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color(.secondarySystemBackground))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.22), lineWidth: 1)
                )
        }
    }
}

// A gentle concave curve used to separate header and form
private struct CurvedTopShape: Shape {
    let curveHeightRatio: CGFloat // fraction of rect.height used to draw curve

    func path(in rect: CGRect) -> Path {
        let curveH = rect.height * curveHeightRatio
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - curveH))

        path.addQuadCurve(
            to: CGPoint(x: 0, y: rect.height - curveH),
            control: CGPoint(x: rect.midX, y: rect.height + curveH)
        )

        path.closeSubpath()
        return path
    }
}

// MARK: - Color helpers

private extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Preview

#if DEBUG
struct PasswordRecoveryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PasswordRecoveryView()
                .previewDevice("iPhone 14 Pro")

            PasswordRecoveryView()
                .previewDevice("iPhone SE (3rd generation)")
                .environment(\.sizeCategory, .accessibilityExtraLarge)
        }
    }
}
#endif
