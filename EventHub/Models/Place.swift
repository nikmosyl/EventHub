//
//  Place.swift
//  EventHub
//
//  Created by Наташа Спиридонова on 16.09.2025.
//


import Foundation

// MARK: - Место
struct Place: Decodable, Sendable {
    let id: Int
    let title: String?
    let address: String?
    let subway: String?
    let location: String?
    let coords: Coords?
}
