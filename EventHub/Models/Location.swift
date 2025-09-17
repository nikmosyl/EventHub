//
//  Location.swift
//  EventHub
//
//  Created by Наташа Спиридонова on 16.09.2025.
//


import Foundation

// MARK: - Локация
struct Location: Decodable, Sendable {
    let slug: String?
    let name: String?
    let coords: Coords?
}
