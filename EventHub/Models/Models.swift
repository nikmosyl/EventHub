//
//  Models.swift
//  EventHub
//
//  Created by Наташа Спиридонова on 08.09.2025.
//

import Foundation

// MARK: - Фильтры для событий
struct EventFilters {
    let location: String?
    let actualSince: Int?
    let actualUntil: Int?
    let categories: [String]?
    let isFree: Bool?
    let price: String?
    let ageRestriction: String?
    let tags: [String]?
    let search: String?
    let page: Int?
    let pageSize: Int?
    
    init(
        location: String? = nil,
        actualSince: Int? = nil,
        actualUntil: Int? = nil,
        categories: [String]? = nil,
        isFree: Bool? = nil,
        price: String? = nil,
        ageRestriction: String? = nil,
        tags: [String]? = nil,
        search: String? = nil,
        page: Int? = nil,
        pageSize: Int? = nil
    ) {
        self.location = location
        self.actualSince = actualSince
        self.actualUntil = actualUntil
        self.categories = categories
        self.isFree = isFree
        self.price = price
        self.ageRestriction = ageRestriction
        self.tags = tags
        self.search = search
        self.page = page
        self.pageSize = pageSize
    }
}

// MARK: - Категория события
struct EventCategory: Decodable, Sendable {
    let id: Int
    let slug: String
    let name: String
}

// MARK: - Категория места
struct PlaceCategory: Decodable, Sendable {
    let id: Int
    let slug: String
    let name: String
}

// MARK: - Локация
struct Location: Decodable, Sendable {
    let slug: String
    let name: String?
}

// MARK: - Модель страницы
struct PagedResponse<T: Decodable>: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [T]
}

// MARK: - Агент
struct Agent: Decodable, Sendable {
    let id: Int
    let title: String
    let slug: String
}

// MARK: - Роль агента
struct AgentRole: Decodable, Sendable {
    let id: Int
    let name: String?
    let namePlural: String?
}

// MARK: - Событие
struct EventItem: Decodable, Sendable {
    let id: Int
    let title: String
    let dates: [EventDate]?
}

// MARK: - Дата события
struct EventDate: Decodable, Sendable {
    let start: Int?
    let end: Int?
    let startDate: String?
    let endDate: String?
    let startTime: String?
    let endTime: String?
}

// MARK: - Событие дня
struct EventOfTheDay: Decodable, Sendable {
    let date: String
    let location: String
    let object: EventOfTheDayObject
    let title: String

    // MARK: - Объект события дня
    struct EventOfTheDayObject: Decodable, Sendable {
        let id: Int
        let ctype: String
    }
}

// MARK: - Новости
struct NewsItem: Decodable, Sendable {
    let id: Int
    let publicationDate: Int
    let title: String
    let slug: String
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
    let title: String
    let slug: String
    let address: String
    let phone: String
    let siteUrl: String
    let subway: String
    let isClosed: Bool
    let location: String
    let hasParkingLot: Bool
}

// MARK: - Показ фильма
struct MovieShowing: Decodable, Sendable {
    let id: Int
    let movie: MovieReference
    let place: PlaceReference
    let datetime: Int
    let threeD: Bool
    let imax: Bool
    let fourDx: Bool
    let originalLanguage: Bool
    let price: String

    // MARK: - Ссылка на фильм
    struct MovieReference: Decodable, Sendable {
        let id: Int
    }
}

// MARK: - Ссылка на место
struct PlaceReference: Decodable, Sendable {
    let id: Int
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
struct EventDetails: Decodable, Sendable {
    let id: Int
    let title: String?
    let slug: String?
    let description: String?
    let bodyText: String?
    let shortTitle: String?
    let tagline: String?
    let dates: [EventDate]?
    let location: Location?
    let place: PlaceReference?
    let price: String?
    let isFree: Bool?
    let images: [EventImage]?
    let siteUrl: String?
    let tags: [String]?
    let categories: [String]?
    //let ageRestriction: String?
    let participants: [String]?
    let favoritesCount: Int?
    let commentsCount: Int?
    let disableComments: Bool?
    
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
}
