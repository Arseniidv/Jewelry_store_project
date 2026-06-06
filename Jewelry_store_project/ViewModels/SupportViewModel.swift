import UIKit
import WidgetKit

@Observable
final class SupportViewModel {
    private(set) var isLoading = false
    var showAlert = false
    private(set) var alertTitle = ""
    private(set) var alertMessage = ""
    private(set) var didSucceed = false

    private let serverURL = URL(string: "http://192.168.1.65:5678/webhook-test/")!

    func sendFeedback(subject: String, message: String) async {
        isLoading = true
        showAlert = false
        didSucceed = false

        defer { isLoading = false }

        let deviceInfo = UIDevice.current.model + " " + UIDevice.current.systemVersion

        let payload: [String: String] = [
            "subject": subject,
            "message": message,
            "device_info": deviceInfo,
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: payload) else {
            presentAlert(title: "Error", message: "Failed to encode request.")
            return
        }

        var request = URLRequest(url: serverURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        request.timeoutInterval = 15

        do {
            let (_, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                presentAlert(title: "Error", message: "Invalid server response.")
                return
            }

            switch httpResponse.statusCode {
            case 200...299:
                didSucceed = true
                let shared = UserDefaults(suiteName: "group.com.jewelrystore")
                shared?.set("Feedback Sent", forKey: "last_title")
                shared?.set("Thank you for your report. We will review your message shortly.", forKey: "last_body")
                WidgetCenter.shared.reloadTimelines(ofKind: "JewelryNotificationsWidget")
                presentAlert(title: "Success", message: "Your message has been sent. We'll get back to you shortly.")
            case 400:
                presentAlert(title: "Error", message: "Invalid request. Please check your input.")
            case 500...599:
                presentAlert(title: "Error", message: "Server error. Please try again later.")
            default:
                presentAlert(title: "Error", message: "Unexpected response (\(httpResponse.statusCode)).")
            }
        } catch let error as URLError {
            print("[SupportViewModel] Request failed for URL: \(serverURL)")
            print("[SupportViewModel] Error code: \(error.code.rawValue), description: \(error.localizedDescription)")

            switch error.code {
            case .notConnectedToInternet:
                presentAlert(title: "Error", message: "No internet connection.")
            case .timedOut:
                presentAlert(title: "Error", message: "Request timed out. Try again.")
            default:
                presentAlert(title: "Error", message: "Network error: \(error.localizedDescription)")
            }
        } catch {
            print("[SupportViewModel] Request failed for URL: \(serverURL)")
            print("[SupportViewModel] Unexpected error: \(error.localizedDescription)")
            presentAlert(title: "Error", message: "An unexpected error occurred.")
        }
    }

    private func presentAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}
