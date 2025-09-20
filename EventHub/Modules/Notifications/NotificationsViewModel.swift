//
//  NotificationViewModel.swift
//  EventHub
//
//  Created by nikita on 20.09.2025.
//

import Foundation

@MainActor
final class NotificationsViewModel: ObservableObject {
    @Published private(set) var notifications: [Event] = []
    @Published private(set) var isLoading = false

    func loadNotifications() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let ids = DataManager.shared.getFavoritesIds()
            let events = try await DataManager.shared.getEventsByIds(ids: ids)
            
            self.notifications = events
        } catch {
            print("Не получилось загрузить избранные евенты, ошибка:", error)
        }
    }
}
