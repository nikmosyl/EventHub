//
//  ExploreModel.swift
//  EventHub
//
//  Created by Drolllted on 14.09.2025.
//

import Foundation
import SwiftUI

//MARK: - Section

struct CategoryCellViewModel: Identifiable {
    let id: String
    let name: String
    let icon: String
    let color: Color
    
    init(category: EventCategory) {
        self.id = "\(category.id)"
        self.name = category.name
        self.icon = CategoryCellViewModel.iconForCategory(category.name)
        self.color = CategoryCellViewModel.colorForCategory(category.name)
    }
    
    private static func iconForCategory(_ category: String) -> String {
        switch category.lowercased() {
        case "sports", "sport": return "basketball.fill"
        case "music", "concert": return "music.note"
        case "food", "restaurants": return "fork.knife"
        case "art", "exhibition": return "photo.fill"
        case "theater", "performance": return "theatermasks.fill"
        case "education", "lecture": return "book.fill"
        case "party", "nightlife": return "sparkles"
        default: return "circle.fill"
        }
    }
    
    private static func colorForCategory(_ category: String) -> Color {
        switch category.lowercased() {
        case "sports", "sport": return Color.pillColor1
        case "music", "concert": return Color.pillColor2
        case "food", "restaurants": return Color.pillColor3
        case "art", "exhibition": return Color.pillColor4
        case "theater", "performance": return Color.pillColor1
        case "education", "lecture": return Color.pillColor2
        case "party", "nightlife": return Color.pillColor3
        default: return Color.pillColor4
        }
    }
}

//MARK: - EventCard

struct EventCardViewModel: Identifiable {
    let id: Int
    let title: String
    let date: String
    let location: String
    let imageUrl: String?
    let peopleCount: String
    let price: String
    
    init(event: Event) {
        self.id = event.id ?? 0
        self.title = event.title
        self.date = EventCardViewModel.formatDate(event.dates?.first?.start)
        self.location = EventCardViewModel.formatLocation(event.place, event.location)
        self.imageUrl = event.images?.first?.image
        self.peopleCount = EventCardViewModel.formatPeopleCount(event.favoritesCount)
        self.price = event.price ?? "Free"
    }
    
    private static func formatDate(_ timestamp: Int?) -> String {
        guard let timestamp = timestamp else { return "Date TBD" }
        
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "dd\nMMMM"
        return formatter.string(from: date).uppercased()
    }
    
    private static func formatLocation(_ place: Place?, _ location: Location?) -> String {
        if let address = place?.address {
            return address
        } else if let locationName = location?.name {
            return locationName
        }
        return "Location TBD"
    }
    
    private static func formatPeopleCount(_ count: Int?) -> String {
        guard let count = count, count > 0 else { return "Be the first!" }
        return "+\(count) Going"
    }
}
