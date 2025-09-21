//
//  MapPinModel.swift
//  EventHub
//
//  Created by nikita on 22.09.2025.
//

import SwiftUI

struct PinModel: Identifiable {
    let id: Int
    let lat: Double
    let lon: Double
    let category: String
    let color: Color
    let icon: String
    
    // Словарь иконок по категориям
    static let icons: [String: String] = [
        "business-events": "briefcase",
        "cinema": "film",
        "concert": "music.note",
        "education": "book",
        "entertainment": "party.popper",
        "exhibition": "rectangle.grid.2x2",
        "fashion": "hanger",
        "festival": "flag",
        "holiday": "gift",
        "kids": "teddybear",
        "other": "ellipsis",
        "party": "music.mic",
        "photo": "camera",
        "quest": "puzzlepiece",
        "recreation": "figure.run",
        "shopping": "cart",
        "social-activity": "heart",
        "stock": "tag",
        "theater": "theatermasks",
        "tour": "map",
        "yarmarki-razvlecheniya-yarmarki": "tent"
    ]
    
    // Словарь цветов по категориям
    static let colors: [String: Color] = [
        "business-events": .pillColor1,
        "cinema": .pillColor2,
        "concert": .pillColor3,
        "education": .pillColor4,
        "entertainment": .pillColor1,
        "exhibition": .pillColor2,
        "fashion": .pillColor3,
        "festival": .pillColor4,
        "holiday": .pillColor1,
        "kids": .pillColor2,
        "other": .pillColor3,
        "party": .pillColor4,
        "photo": .pillColor1,
        "quest": .pillColor2,
        "recreation": .pillColor3,
        "shopping": .pillColor4,
        "social-activity": .pillColor1,
        "stock": .pillColor2,
        "theater": .pillColor3,
        "tour": .pillColor4,
        "yarmarki-razvlecheniya-yarmarki": .pillColor1
    ]
    
    init?(event: Event) {
        guard
            let id = event.id,
            let lat = event.place?.coords?.lat,
            let lon = event.place?.coords?.lon
        else {
            return nil
        }
        
        self.id = id
        self.lat = lat
        self.lon = lon
        
        let category = event.categories?.first ?? "other"
        
        self.category = category
        self.icon = PinModel.icons[category] ?? "party.popper.fill"
        self.color = PinModel.colors[category] ?? .gray
    }
}


