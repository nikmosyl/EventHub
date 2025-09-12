//
//  Models.swift
//  EventHub
//
//  Created by Наташа Спиридонова on 08.09.2025.
//

import Foundation

// MARK: - Модель страницы
struct PagedResponse<T: Decodable>: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [T]
}

// MARK: - Фильтры для событий
struct EventFilters {
    let location: String?
    let actualSince: Int?
    let actualUntil: Int?
    let categories: [String]?
    let price: String?
    let search: String?
    let page: Int?
    let fields: [String]?
    let expand: [String]?
    
    init(
        location: String? = nil,
        actualSince: Int? = nil,
        actualUntil: Int? = nil,
        categories: [String]? = nil,
        search: String? = nil,
        page: Int? = nil,
        price: String? = nil,
        fields: [String]? = nil,
        expand: [String]? = nil
    ) {
        self.location = location
        self.actualSince = actualSince
        self.actualUntil = actualUntil
        self.categories = categories
        self.search = search
        self.page = page
        self.price = price
        self.fields = fields
        self.expand = expand
    }
}

// MARK: - Категория события
struct EventCategory: Decodable, Sendable {
    let id: Int
    let name: String
}


// MARK: - Локация
struct Location: Decodable, Sendable {
    let slug: String
    let name: String?
}

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

// MARK: - Подборки
struct ListItem: Decodable, Sendable {
    let id: Int
    let publicationDate: Int
    let title: String
    let slug: String
    let siteUrl: String?
}


// MARK: - Место
struct Place: Decodable, Sendable {
    let id: Int
    let title: String?
    let address: String?
    let subway: String?
    let location: String?
    let coords: Сoords?
}

// MARK: - Координаты
struct Сoords: Decodable, Sendable {
    let lat: Double?
    let lon: Double?
}

// MARK: - Фильм
struct Movie: Decodable, Sendable {
    let id: Int
    let title: String
    let poster: MoviePoster?
    
    // MARK: - Постер фильма
    struct MoviePoster: Decodable, Sendable {
        let image: String
        let source: PosterSource?
        
        // MARK: - Источник постера
        struct PosterSource: Decodable, Sendable {
            let name: String
            let link: String
        }
    }
}

// MARK: - Детальная информация о событии
struct Event: Decodable, Sendable {
    let id: Int?
    let title: String
    let slug: String
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
        guard let dates = dates else { return nil }
        let now = Int(Date().timeIntervalSince1970)
        return dates
            .filter { ($0.start ?? 0) >= now }
            .min { ($0.start ?? 0) < ($1.start ?? 0) }
    }
    
    var previousDate: EventDate? {
        guard let dates = dates else { return nil }
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
