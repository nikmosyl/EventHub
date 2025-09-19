//
//  Notification.swift
//  EventHub
//
//  Created by Анастасия Тихонова on 18.09.2025.
//

import SwiftUI

// MARK: - Model
struct NotificationItem: Identifiable {
    let id: Int
    let title: String
    let date: Date
}

// MARK: - ViewModel
@MainActor
class NotificationViewModel: ObservableObject {
    @Published var notifications: [NotificationItem] = []
    @Published var showEmptyView = false
    @Published var notificationCount = 0

    func loadNotifications() {
        notifications = [
            NotificationItem(
                id: 1,
                title: "International Band Music Concert coming soon!",
                date: Date()
            ),
            NotificationItem(
                id: 2,
                title: "International Band Music Concert coming soon!",
                date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!
            ),
            NotificationItem(
                id: 3,
                title: "International Band Music Concert coming soon!",
                date: Calendar.current.date(byAdding: .day, value: -14, to: Date())!
            )
        ]
        showEmptyView = notifications.isEmpty
    }

    func loadNotificationCount() async {
        do {
            notificationCount = try await DataManager.shared.getNotificationsCount()
        } catch {
            notificationCount = 0
        }
    }
}

// MARK: - Views

struct EmptyNotificationView: View {
    let count: Int
    let onButtonTap: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            ZStack(alignment: .bottomTrailing) {
                Image("bell")
                    .resizable()
                    .frame(width: 136, height: 168)
                    .shadow(color: .gray, radius: 40)

                Image("bell")
                    .resizable()
                    .frame(width: 156, height: 170)
                    .overlay(
                        Image("face")
                            .resizable()
                            .frame(width: 46, height: 26)
                            .offset(y: 68),
                        alignment: .top
                    )

                Button {
                    onButtonTap()
                } label: {
                    Text("\(count)")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .frame(width: 35.2, height: 35.2)
                        .background(Color("buttonPrimary"))
                        .clipShape(Circle())
                }
            }

            HStack {
                Text("No Notifications!")
                    .font(.system(size: 18, weight: .medium))
                    .frame(width: 146, height: 34)
                    .multilineTextAlignment(.center)
                    .padding(.leading, 55)
                Spacer()
            }

            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit sed do eiusmod tempor")
                .frame(width: 336, height: 56)
                .font(.custom("Airbnb Cereal App", size: 16))
                .fontWeight(.regular)
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.center)
                .lineSpacing(12)
                .padding(.leading, 20)
        }
        .frame(width: 336)
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .navigationBarTitle("Notification", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    // действие кнопки "назад"
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 22))
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

struct NotificationsListView: View {
    let notifications: [NotificationItem]
    @Binding var showEmptyView: Bool

    var body: some View {
        ScrollView {
            VStack(spacing: 7) {
                ForEach(notifications) { notification in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(notification.title)
                            .font(.system(size: 14))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)

                        Text(notification.date.timeAgoDisplay())
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                    .padding(16)
                    .frame(maxWidth: 335, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                }
            }
        }
        .padding(.vertical, 25)
        .navigationBarTitle("Notification", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    showEmptyView = true
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 22))
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

struct NotificationView: View {
    @StateObject private var viewModel = NotificationViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.showEmptyView || viewModel.notifications.isEmpty {
                    EmptyNotificationView(count: viewModel.notificationCount) {
                        viewModel.showEmptyView = false
                        viewModel.loadNotifications()
                    }
                } else {
                    NotificationsListView(notifications: viewModel.notifications, showEmptyView: $viewModel.showEmptyView)
                }
            }
            .onAppear {
                Task {
                    await viewModel.loadNotificationCount()
                    viewModel.loadNotifications()
                }
            }
        }
    }
}

// MARK: - Date extension
extension Date {
    func timeAgoDisplay() -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(self) {
            return "Just now"
        }
        if let days = calendar.dateComponents([.day], from: self, to: Date()).day {
            return "\(days) day\(days > 1 ? "s" : "") ago"
        }
        return ""
    }
}

// MARK: - DataManager extension
extension DataManager {
    private func fetchEvents(filters: EventFilters = EventFilters(), id: Int? = nil) async throws -> [Event] {
        // Заглушка для компиляции
        return []
    }

    func getNotificationsCount() async throws -> Int {
        let events = try await fetchEvents()
        return events.count
    }
}

// MARK: - Previews

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NotificationView()
                .previewDisplayName("With Notifications")

            NotificationViewEmptyPreview()
                .previewDisplayName("Empty Notifications")
        }
    }
}

struct NotificationViewEmptyPreview: View {
    @State private var showEmptyView = true
    @State private var notificationCount = 0

    var body: some View {
        NavigationView {
            ZStack {
                if showEmptyView {
                    EmptyNotificationView(count: notificationCount) {
                        showEmptyView = false
                    }
                } else {
                    NotificationsListView(notifications: [], showEmptyView: $showEmptyView)
                }
            }
        }
    }
}
