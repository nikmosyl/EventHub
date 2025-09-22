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
        let favorites = favoritesCount ?? 0
        let participantsCount = participants?.count ?? 0
        return favorites + participantsCount
    }
    
    var locationName: String {
        place?.title ?? place?.address ?? location?.name ?? "No Location"
    }
    
    var formattedEventDate: String {
        let dateFormat = "dd\nMMM"
        
        if let nextDate = nextDate,
           let startTime = nextDate.start {
            return nextDate.formatter(date: startTime, format: dateFormat)
        }
        else if let previousDate = previousDate,
                let startTime = previousDate.start {
            return previousDate.formatter(date: startTime, format: dateFormat)
        }
        else if let firstDate = dates?.first,
                let startTime = firstDate.start {
            return firstDate.formatter(date: startTime, format: dateFormat)
        }
        
        return "Дата не указана"
    }
}
