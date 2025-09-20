//
//  NotificationCardViewModel.swift
//  EventHub
//
//  Created by nikita on 20.09.2025.
//

import Foundation

final class NotificationCardViewModel: ObservableObject {
    let notification: Event
    
    init(notification: Event) {
        self.notification = notification
    }
    
    func calulatePeriod() -> String {
        let now = Int(Date().timeIntervalSince1970)
        if let next = notification.nextDate, let start = next.start {
            if start - 60 * 60 * 24 < now  {
                return "Today"
            } else if start - 60 * 60 * 24 * 2 < now {
                return "in 1 day"
            }
            return "in \(next.formatter(date: start, format: "d")) days"
        }
        
        if let previous = notification.previousDate, let start = previous.start {
            if start + 60 * 60 * 24 > now  {
                return "Today"
            } else if start + 60 * 60 * 24 * 2 > now {
                return "1 day ago"
            }
            return "\(previous.formatter(date: start, format: "d")) days ago"
        }
        
        return "The date of the event is unknown"
    }
}
