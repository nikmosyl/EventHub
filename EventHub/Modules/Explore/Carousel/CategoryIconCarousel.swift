//
//  CategoryIconCarousel.swift
//  EventHub
//
//  Created by Drolllted on 16.09.2025.
//

import Foundation

struct CategoryIconCarousel {
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
    
    static func icon(for categoryName: String) -> String {
        return icons[categoryName] ?? "pencil"
    }
}
