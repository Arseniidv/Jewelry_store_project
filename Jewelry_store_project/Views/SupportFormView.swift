import SwiftUI
import WidgetKit

struct SupportFormView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = SupportViewModel()
    @State private var subject = ""
    @State private var message = ""

    private var isFormValid: Bool {
        !subject.trimmingCharacters(in: .whitespaces).isEmpty &&
        !message.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $subject)
                        .disabled(viewModel.isLoading)
                }

                Section {
                    TextEditor(text: $message)
                        .frame(minHeight: 200)
                        .disabled(viewModel.isLoading)
                } header: {
                    Text("Enter you text downbelow")
                }
            }
            .appScreenBackground()
            .navigationTitle("Contact Support")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .disabled(viewModel.isLoading)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Send") { send() }
                        .fontWeight(.semibold)
                        .disabled(!isFormValid || viewModel.isLoading)
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Sending...")
                        .padding(24)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                }
            }
            .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
                Button("OK") {
                    if viewModel.didSucceed { dismiss() }
                }
            } message: {
                Text(viewModel.alertMessage)
            }
            .interactiveDismissDisabled(viewModel.isLoading)
            .onChange(of: viewModel.didSucceed) { _, newValue in
                if newValue {
                    WidgetCenter.shared.reloadTimelines(ofKind: "JewelryNotificationsWidget")
                    dismiss()
                }
            }
        }
    }

    private func send() {
        guard isFormValid else { return }
        let trimmedSubject = subject.trimmingCharacters(in: .whitespaces)
        let trimmedMessage = message.trimmingCharacters(in: .whitespaces)
        Task {
            await viewModel.sendFeedback(subject: trimmedSubject, message: trimmedMessage)
        }
    }
}

#Preview {
    SupportFormView()
}
