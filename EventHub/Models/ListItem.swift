//
//  ListItem.swift
//  EventHub
//
//  Created by Наташа Спиридонова on 16.09.2025.
//


import Foundation

// MARK: - Подборки
struct ListItem: Decodable, Sendable {
    let id: Int
    let publicationDate: Int
    let title: String
    let slug: String
    let siteUrl: String?
}
