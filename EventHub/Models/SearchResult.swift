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

extension SearchResult {
    init(from event: Event) {
        self.id = event.id
        self.slug = nil
        self.title = event.title
        self.description = event.description
        self.itemUrl = event.siteUrl
        self.coords = event.location?.coords
        self.daterange = event.dates?.first
        self.firstImage = event.images?.first.map { img in
            SearchResultImage(image: img.image)
        }
    }
}
