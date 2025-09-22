//
//  NotificationService.swift
//  EventHub
//
//  Created by nikita on 22.09.2025.
//

import Foundation

import Foundation
import UserNotifications

final class NotificationService {
    
    static let shared = NotificationService()
    private init() {}
    
    func requestAuthorization() async throws {
        let center = UNUserNotificationCenter.current()
        try await center.requestAuthorization(options: [.alert, .sound, .badge])
    }
    
    func scheduleNotifications(for event: Event) {
        guard let startTimestamp = event.nextDate?.start else { return }
        
        let startDate = Date(timeIntervalSince1970: TimeInterval(startTimestamp))
        let now = Date()
        
        let daysBefore = [7, 3, 1]
        
        for days in daysBefore {
            let fireDate = Calendar.current.date(byAdding: .day, value: -days, to: startDate)!
            
            guard fireDate > now else { continue }
            
            scheduleNotification(
                id: "\(event.id ?? 0)-\(days)",
                title: event.title ?? "Событие",
                body: "До начала события «\(event.shortTitle ?? event.title ?? "")» осталось \(days) дн.",
                fireDate: fireDate
            )
        }
    }
    
    private func scheduleNotification(id: String, title: String, body: String, fireDate: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let triggerDate = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: fireDate
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Ошибка при добавлении уведомления: \(error.localizedDescription)")
            }
        }
    }
    
    func cancelNotifications(for event: Event) {
        guard let id = event.id else { return }
        let identifiers = ["\(id)-7", "\(id)-3", "\(id)-1"]
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}
