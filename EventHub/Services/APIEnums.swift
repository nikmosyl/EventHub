//
//  APIEnums.swift
//  EventHub
//
//  Created by Наташа Спиридонова on 09.09.2025.
//

import Foundation

// MARK: - Конфигурация API
enum APIConfig {
    static let baseURL = URL(string: "https://kudago.com/public-api/v1.4")!
}

// MARK: - Ошибки сети
enum NetworkError: Error {
    case invalidURL, invalidResponse, badStatus(Int), decoding(Error)
}

// MARK: - Запросы API
enum APIRequest {
    case eventCategories
    case placeCategories
    case agents(page: Int? = nil)
    case agentRoles(lang: String = "ru")
    case events(filters: EventFilters)
    case eventsOfTheDay(location: String? = nil, date: String? = nil)
    case news(page: Int? = nil)
    case lists(page: Int? = nil)
    case places(page: Int? = nil)
    case locations
    case movieShowings(page: Int? = nil)
    case movies(page: Int? = nil)
    case eventDetails(id: Int)

    // MARK: - Путь запроса
    var path: String {
        switch self {
        case .eventCategories: return "event-categories/"
        case .placeCategories: return "place-categories/"
        case .agents: return "agents/"
        case .agentRoles: return "agent-roles/"
        case .events: return "events/"
        case .eventsOfTheDay: return "events-of-the-day/"
        case .news: return "news/"
        case .lists: return "lists/"
        case .places: return "places/"
        case .locations: return "locations/"
        case .movieShowings: return "movie-showings/"
        case .movies: return "movies/"
        case .eventDetails(let id): return "events/\(id)/"
        }
    }

    // MARK: - Параметры запроса
    var query: [URLQueryItem] {
        switch self {
        case .eventCategories, .placeCategories, .locations, .eventDetails:
            return []
        
        case let .agentRoles(lang):
            return [.init(name: "lang", value: lang)]
        
        case let .events(filters):
            var items: [URLQueryItem] = []
            
            // Обязательные параметры
            if let location = filters.location {
                items.append(.init(name: "location", value: location))
            }
            if let actualSince = filters.actualSince {
                items.append(.init(name: "actual_since", value: String(actualSince)))
            }
            if let actualUntil = filters.actualUntil {
                items.append(.init(name: "actual_until", value: String(actualUntil)))
            }
            
            // Опциональные фильтры
            if let categories = filters.categories, !categories.isEmpty {
                items.append(.init(name: "categories", value: categories.joined(separator: ",")))
            }
            if let isFree = filters.isFree {
                items.append(.init(name: "is_free", value: String(isFree)))
            }
            if let price = filters.price {
                items.append(.init(name: "price", value: price))
            }
            if let ageRestriction = filters.ageRestriction {
                items.append(.init(name: "age_restriction", value: ageRestriction))
            }
            if let tags = filters.tags, !tags.isEmpty {
                items.append(.init(name: "tags", value: tags.joined(separator: ",")))
            }
            if let search = filters.search {
                items.append(.init(name: "search", value: search))
            }
            
            // Пагинация
            if let page = filters.page {
                items.append(.init(name: "page", value: String(page)))
            }
            if let pageSize = filters.pageSize {
                items.append(.init(name: "page_size", value: String(pageSize)))
            } else {
                items.append(.init(name: "page_size", value: "20")) // По умолчанию
            }
            
            return items
        
        case let .eventsOfTheDay(location, date):
            var items: [URLQueryItem] = []
            if let location = location {
                items.append(.init(name: "location", value: location))
            }
            if let date = date {
                items.append(.init(name: "date", value: date))
            }
            return items
        
        case let .agents(page), let .news(page), let .lists(page),
             let .places(page), let .movieShowings(page), let .movies(page):
            var items: [URLQueryItem] = []
            if let page = page {
                items.append(.init(name: "page", value: String(page)))
            }
            return items
        }
    }

    // MARK: - Создание URL запроса
    func urlRequest() throws -> URLRequest {
        var components = URLComponents(url: APIConfig.baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        components?.queryItems = query
        guard let url = components?.url else { throw NetworkError.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}
