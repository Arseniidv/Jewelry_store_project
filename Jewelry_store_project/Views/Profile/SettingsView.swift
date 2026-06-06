import SwiftUI

struct SettingsView: View {
    @AppStorage("theme") private var theme: ThemeOption = .system
    @AppStorage("fontSize") private var fontSize: FontSizeOption = .medium
    @AppStorage("pushEnabled") private var pushEnabled = true
    @AppStorage("orderUpdates") private var orderUpdates = true
    @AppStorage("promotions") private var promotions = false
    @AppStorage("currency") private var currency: CurrencyOption = .usd
    @AppStorage("language") private var language: LanguageOption = .english
    @State private var showSupportForm = false

    var body: some View {
        Form {
            appearanceSection
            notificationsSection
            shoppingSection
            aboutSection
        }
        .appScreenBackground()
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
    }

    private var appearanceSection: some View {
        Section {
            Picker(selection: $theme) {
                ForEach(ThemeOption.allCases) { option in
                    Label(option.label, systemImage: option.icon)
                        .tag(option)
                }
            } label: {
                Label("Theme", systemImage: "paintpalette")
            }

            Picker(selection: $fontSize) {
                ForEach(FontSizeOption.allCases) { option in
                    Text(option.label).tag(option)
                }
            } label: {
                Label("Font Size", systemImage: "textformat.size")
            }
        } header: {
            Text("Appearance")
        }
    }

    private var notificationsSection: some View {
        Section {
            Toggle(isOn: $pushEnabled) {
                Label("Push Notifications", systemImage: "bell.badge")
            }

            Toggle(isOn: $orderUpdates) {
                Label("Order Updates", systemImage: "shippingbox")
            }
            .disabled(!pushEnabled)

            Toggle(isOn: $promotions) {
                Label("Promotions & Offers", systemImage: "tag")
            }
            .disabled(!pushEnabled)
        } header: {
            Text("Notifications")
        } footer: {
            if !pushEnabled {
                Text("Enable push notifications to receive order updates and offers.")
            }
        }
    }

    private var shoppingSection: some View {
        Section {
            Picker(selection: $currency) {
                ForEach(CurrencyOption.allCases) { option in
                    Text(option.label).tag(option)
                }
            } label: {
                Label("Currency", systemImage: "dollarsign.circle")
            }

            Picker(selection: $language) {
                ForEach(LanguageOption.allCases) { option in
                    Text(option.label).tag(option)
                }
            } label: {
                Label("Language", systemImage: "globe")
            }
        } header: {
            Text("Shopping")
        }
    }

    private var aboutSection: some View {
        Section {
            HStack {
                Label("Version", systemImage: "info.circle")
                Spacer()
                Text("1.0.0")
                    .foregroundStyle(AppTheme.secondaryText)
            }

            Button {
                // Rate the app
            } label: {
                Label("Rate the App", systemImage: "star")
            }

            Button {
                showSupportForm = true
            } label: {
                Label("Contact Support", systemImage: "envelope")
            }
        } header: {
            Text("About")
        }
        .sheet(isPresented: $showSupportForm) {
            SupportFormView()
        }
    }
}
