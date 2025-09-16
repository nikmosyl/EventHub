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
        place?.title ?? place?.address ?? location?.name ?? "Unknown location"
    }
    
    var isFree: Bool {
        price?.lowercased() == "free" || price == "0" || price == nil
    }
    
    var formattedPrice: String {
        if isFree {
            return "Free"
        } else if let price = price {
            return price
        }
        return "Paid"
    }
    
    var formattedDate: String {
        guard let nextDate = nextDate,
              let startTime = nextDate.start else {
            return "Date not specified"
        }
        
        let date = Date(timeIntervalSince1970: TimeInterval(startTime))
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, HH:mm"
        return formatter.string(from: date)
    }
}
