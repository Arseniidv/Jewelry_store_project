import SwiftUI

/// Bell control with a popover anchored to the button (arrow points at the bell).
struct NotificationBellButton: View {
    @State private var isPresented = false
    var iconSize: CGFloat = 22
    
    var body: some View {
        Button {
            isPresented.toggle()
        } label: {
            Image(systemName: "bell")
                .font(.system(size: iconSize, weight: .medium))
                .foregroundStyle(AppTheme.primaryText)
                .frame(width: 44, height: 44)
                .background(AppTheme.surfaceMuted)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .popover(isPresented: $isPresented, attachmentAnchor: .rect(.bounds), arrowEdge: .top) {
            NotificationsPopoverView()
                .presentationCompactAdaptation(.popover)
        }
    }
}

#Preview {
    NotificationBellButton()
        .padding()
}
