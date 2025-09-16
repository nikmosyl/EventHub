//
//  EventDate.swift
//  EventHub
//
//  Created by Наташа Спиридонова on 16.09.2025.
//


import Foundation

// MARK: - Дата события
struct EventDate: Decodable, Sendable, Hashable {
    let start: Int?
    let end: Int?
    
    func formatter(date: Int, format: String) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(date))
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}
