//
//  EventCategory.swift
//  EventHub
//
//  Created by Наташа Спиридонова on 16.09.2025.
//


import Foundation

// MARK: - Категория события
struct EventCategory: Decodable, Sendable {
    let id: Int?
    let name: String?
}
