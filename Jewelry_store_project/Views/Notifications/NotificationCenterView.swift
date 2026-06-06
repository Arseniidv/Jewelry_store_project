import SwiftUI
import SwiftData

struct NotificationCenterView: View {
    let viewModel: NotificationCenterViewModel

    @Query(sort: \NotificationEntity.timestamp, order: .reverse)
    private var notifications: [NotificationEntity]

    var body: some View {
        List {
            if notifications.isEmpty {
                ContentUnavailableView(
                    "No notifications",
                    systemImage: "bell.slash",
                    description: Text("You're all caught up.")
                )
                .listRowBackground(Color.clear)
            } else {
                ForEach(notifications) { entity in
                    NotificationCenterRow(entity: entity)
                        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.markAsRead(entity)
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            if !entity.isRead {
                                Button {
                                    viewModel.markAsRead(entity)
                                } label: {
                                    Label("Read", systemImage: "envelope.open")
                                }
                                .tint(.blue)
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                viewModel.deleteNotification(entity)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(AppTheme.screenBackground)
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                if !notifications.isEmpty {
                    Menu {
                        if notifications.contains(where: { !$0.isRead }) {
                            Button("Mark All Read", systemImage: "envelope.open") {
                                viewModel.markAllAsRead()
                            }
                        }
                        Button("Clear All", systemImage: "trash", role: .destructive) {
                            viewModel.clearAllNotifications()
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.system(size: 18))
                    }
                }
            }
        }
    }
}
