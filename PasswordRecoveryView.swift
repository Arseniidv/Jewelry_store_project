import SwiftUI

// Redesigned Password Recovery screen
// Focus: align with app design system, 8-point spacing, accessible, responsive

private enum Design {
    static let spacing: CGFloat = 8
    static let horizontalPadding: CGFloat = 20
    static let cornerRadius: CGFloat = 12
    static let headerFraction: CGFloat = 0.22 // reduced header height (≈30-40% smaller than before)
    static let curveRatio: CGFloat = 0.08 // shallower curve
}

struct PasswordRecoveryView: View {
    @StateObject private var internalVM = PasswordRecoveryViewModel()
    @StateObject var viewModel: PasswordRecoveryViewModel

    init(viewModel: PasswordRecoveryViewModel = PasswordRecoveryViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                Color(.systemBackground).ignoresSafeArea()

                VStack(spacing: 0) {
                    header
                        .frame(height: max(geo.size.height * Design.headerFraction, 160))

                    content
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(.systemGroupedBackground))
                }
                .edgesIgnoringSafeArea(.top)
            }
        }
    }

    private var header: some View {
        ZStack(alignment: .topLeading) {
            // Brand background with a shallow curve
            GeometryReader { g in
                BrandColor
                    .overlay(
                        CurvedTopShape(curveHeightRatio: Design.curveRatio)
                            .fill(Color(.systemBackground))
                            .offset(y: g.size.height * 0.5)
                    )
            }

            HStack {
                backButton
                    .padding(.leading, Design.horizontalPadding)
                Spacer()
            }
            .padding(.top, safeAreaTopPadding())

            VStack(spacing: Design.spacing) {
                // Slightly elevated logo to feel balanced with smaller header
                Text("LOOTIK")
                    .font(.system(size: 32, weight: .regular, design: .serif))
                    .foregroundColor(.white)
                    .tracking(3)
                    .accessibilityAddTraits(.isHeader)

                Text("ювелирный дом")
                    .font(.footnote)
                    .foregroundColor(Color.white.opacity(0.9))
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 12)
        }
    }

    private var content: some View {
        VStack(spacing: Design.spacing * 2) {
            // Title block
            VStack(spacing: Design.spacing) {
                Text("Восстановление пароля")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)

                Text("Введите email — мы отправим ссылку для сброса пароля")
                    .font(.subheadline)
                    .foregroundColor(Color.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Design.horizontalPadding)
            }
            .padding(.top, 16)

            // Email field
            VStack(spacing: Design.spacing / 2) {
                Text("Электронная почта")
                    .font(.caption)
                    .foregroundColor(Color.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                AppTextField(text: $viewModel.email, placeholder: "name@example.com")
            }
            .padding(.horizontal, Design.horizontalPadding)

            // Primary action
            Button(action: { Task { await viewModel.sendRecovery() } }) {
                HStack {
                    Spacer()
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("ОТПРАВИТЬ ССЫЛКУ")
                            .fontWeight(.semibold)
                    }
                    Spacer()
                }
                .frame(height: 50)
                .background(PrimaryGradient())
                .foregroundColor(.white)
                .cornerRadius(Design.cornerRadius)
                .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 3)
            }
            .padding(.horizontal, Design.horizontalPadding)
            .disabled(!viewModel.isEmailValid || viewModel.isLoading)

            Spacer(minLength: 24)
        }
        .padding(.top, -32) // pull the content closer to the header for better balance
    }

    private var backButton: some View {
        Button(action: { viewModel.onBack?() }) {
            HStack(spacing: 8) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .semibold))
                Text("Назад")
                    .font(.subheadline)
            }
            .foregroundColor(.white)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color.white.opacity(0.10))
            .clipShape(Capsule())
        }
        .accessibilityIdentifier("password_recovery_back")
    }

    private func safeAreaTopPadding() -> CGFloat {
        // Reasonable top padding for status bar / notch
        return UIApplication.shared.windows.first?.safeAreaInsets.top ?? 12
    }

    private var BrandColor: Color { Color(hex: "EE6B4F") }
}

// MARK: - Reusable subviews (replace with project's components when available)

private struct AppTextField: View {
    @Binding var text: String
    var placeholder: String = ""

    var body: some View {
        TextField(placeholder, text: $text)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .padding(12)
            .background(RoundedRectangle(cornerRadius: Design.cornerRadius).fill(Color(.secondarySystemBackground)))
            .overlay(RoundedRectangle(cornerRadius: Design.cornerRadius).stroke(Color.gray.opacity(0.22), lineWidth: 1))
            .accessibilityLabel("Электронная почта")
    }
}

private struct PrimaryGradient: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(hex: "EE6B4F"), Color(hex: "E98A72")]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

// Shallow concave curve used to separate header and content. Smaller curve for a subtler effect.
private struct CurvedTopShape: Shape {
    let curveHeightRatio: CGFloat

    func path(in rect: CGRect) -> Path {
        let curveH = rect.height * curveHeightRatio
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - curveH))
        path.addQuadCurve(to: CGPoint(x: 0, y: rect.height - curveH), control: CGPoint(x: rect.midX, y: rect.height + curveH))
        path.closeSubpath()
        return path
    }
}

// MARK: - Color helper

private extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
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

            PasswordRecoveryView()
                .previewDevice("iPhone 15 Pro Max")
        }
    }
}
#endif
