//
//  Event.swift
//  EventHub
//
//  Created by Наташа Спиридонова on 16.09.2025.
//


import Foundation

// MARK: - Детальная информация о событии
struct Event: Decodable, Sendable, Identifiable {
    let id: Int?
    let title: String?
    let description: String?
    let shortTitle: String?
    let dates: [EventDate]?
    let location: Location?
    let place: Place?
    let price: String?
    let images: [EventImage]?
    let favoritesCount: Int?
    let siteUrl: String?
    let categories: [String]?
    let participants: [Participant]?
    
    var nextDate: EventDate? {
        guard let dates else { return nil }
        let now = Int(Date().timeIntervalSince1970)
        return dates
            .filter { ($0.start ?? 0) >= now }
            .min { ($0.start ?? 0) < ($1.start ?? 0) }
    }
    
    var previousDate: EventDate? {
        guard let dates else { return nil }
        let now = Int(Date().timeIntervalSince1970)
        return dates
            .filter { ($0.end ?? 0) < now }
            .max { ($0.end ?? 0) < ($1.end ?? 0) }
    }
    
    // MARK: - Изображение события
    struct EventImage: Decodable, Sendable {
        let image: String?
        let source: ImageSource?
        
        // MARK: - Источник изображения
        struct ImageSource: Decodable, Sendable {
            let name: String?
            let link: String?
        }
    }
    // MARK: - Участник события
    struct Participant: Decodable, Sendable {
        let role: ParticipantRole?
        let agent: ParticipantAgent?
        
        // MARK: - Роль участника
        struct ParticipantRole: Decodable, Sendable {
            let slug: String?
        }
        
        // MARK: - Агент (актер, режиссер и т.д.)
        struct ParticipantAgent: Decodable, Sendable {
            let id: Int?
            let title: String?
            let slug: String?
            let agentType: String?
            let images: [String]?
            let siteUrl: String?
            let isStub: Bool?
        }
    }
}

extension Event {
    init(from searchResult: SearchResult) {
        self.id = searchResult.id
        self.title = searchResult.title
        self.description = searchResult.description
        self.shortTitle = searchResult.title
        self.dates = searchResult.daterange.map { [$0] }
        self.location = searchResult.coords.map { coords in
            Location(slug: nil, name: nil, coords: coords)
        }
        self.images = searchResult.firstImage.map { image in
            [EventImage(image: image.image, source: nil)]
        }
        self.siteUrl = searchResult.itemUrl
        self.categories = nil
        self.participants = nil
        
        self.place = nil
        self.price = nil
        self.favoritesCount = nil
    }
}
