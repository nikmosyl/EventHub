//
//  SearchResult.swift
//  EventHub
//
//  Created by nikita on 22.09.2025.
//

import Foundation

struct SearchResult: Decodable, Sendable, Identifiable {
    let id: Int?
    let slug: String?
    let title: String?
    let description: String?
    let itemUrl: String?
    let coords: Coords?
    let daterange: EventDate?
    let firstImage: SearchResultImage?
}

struct SearchResultImage: Decodable {
    let image: String?
}
