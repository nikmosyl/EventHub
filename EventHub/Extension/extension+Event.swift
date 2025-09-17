//
//  extension+Event.swift
//  EventHub
//
//  Created by Drolllted on 16.09.2025.
//

import Foundation

extension Event {
    var imageUrl: String? {
        images?.first?.image
    }
    
    var participantCount: Int {
        participants?.count ?? 0
    }
    
    var locationName: String {
        place?.title ?? place?.address ?? location?.name ?? "Место не указано"
    }
    
    var isFree: Bool {
        guard let price = price else { return true }
        return price.lowercased() == "free" || price == "0" || price.isEmpty
    }
    
    var formattedPrice: String {
        if isFree {
            return "Бесплатно"
        } else if let price = price, !price.isEmpty {
            return price
        }
        return "Платно"
    }
    
    var formattedDate: String {
        if let nextDate = nextDate,
           let startTime = nextDate.start {
            return formatDate(from: startTime)
        }
        else if let previousDate = previousDate,
                let startTime = previousDate.start {
            return formatDate(from: startTime)
        }
        else if let firstDate = dates?.first,
                let startTime = firstDate.start {
            return formatDate(from: startTime)
        }
        
        return "Дата не указана"
    }
    
    // Вспомогательная функция для форматирования даты
    private func formatDate(from timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_EN")
        formatter.dateFormat = "dd\nMMM"
        return formatter.string(from: date).capitalized
    }
    
    
    // Форматирование количества участников
    var formattedParticipantCount: String {
        let count = participantCount
        switch count {
        case 0:
            return "Нет участников"
        case 1:
            return "1 участник"
        case 2...4:
            return "\(count) участника"
        default:
            return "\(count) участников"
        }
    }
}
