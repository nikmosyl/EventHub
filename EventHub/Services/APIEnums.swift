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

// MARK: - Поля API
enum APIFields {
    static let basic = ["id", "title", "slug"]
    static let category = ["id", "slug", "name"]
    static let news = ["id", "publication_date", "title", "slug"]
    static let place = ["id", "title", "slug", "address", "phone", "site_url", "subway", "is_closed", "location", "has_parking_lot"]
    static let movie = ["id", "title", "poster"]
    static let movieShowing = ["id", "movie", "place", "datetime", "three_d", "imax", "four_dx", "original_language", "price"]
    static let eventOfTheDay = ["date", "location", "object", "title"]
    static let agentRole = ["id", "name", "name_plural"]
    static let event = ["id", "title", "dates"]
}

// MARK: - Ошибки сети
enum NetworkError: Error {
    case invalidURL, invalidResponse, badStatus(Int), decoding(Error)
}

// MARK: - Запросы API
enum APIRequest {
    case eventCategories(fields: [String]? = nil)
    case placeCategories(fields: [String]? = nil)
    case agents(page: Int? = nil, fields: [String]? = nil)
    case agentRoles(lang: String = "ru", fields: [String] = ["id", "name", "name_plural"])
    case events(location: String, since: Int, until: Int, pageSize: Int = 20, fields: [String] = ["id","title","dates"])
    case eventsOfTheDay(location: String? = nil, date: String? = nil, fields: [String]? = nil)
    case news(page: Int? = nil, fields: [String]? = nil)
    case lists(page: Int? = nil, fields: [String]? = nil)
    case places(page: Int? = nil, fields: [String]? = nil)
    case locations
    case movieShowings(page: Int? = nil, fields: [String]? = nil)
    case movies(page: Int? = nil, fields: [String]? = nil)

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
        }
    }

    // MARK: - Параметры запроса
    var query: [URLQueryItem] {
        switch self {
        case let .eventCategories(fields), let .placeCategories(fields):
            return fields.map { [URLQueryItem(name: "fields", value: $0.joined(separator: ","))] } ?? []
        case let .agents(page, fields), let .news(page, fields), let .lists(page, fields),
             let .places(page, fields), let .movieShowings(page, fields), let .movies(page, fields):
            var items: [URLQueryItem] = []
            if let page { items.append(.init(name: "page", value: String(page))) }
            if let fields { items.append(.init(name: "fields", value: fields.joined(separator: ","))) }
            return items
        case let .agentRoles(lang, fields):
            return [.init(name: "lang", value: lang), .init(name: "fields", value: fields.joined(separator: ","))]
        case let .events(location, since, until, pageSize, fields):
            return [
                .init(name: "location", value: location),
                .init(name: "actual_since", value: String(since)),
                .init(name: "actual_until", value: String(until)),
                .init(name: "page_size", value: String(pageSize)),
                .init(name: "fields", value: fields.joined(separator: ","))
            ]
        case let .eventsOfTheDay(location, date, fields):
            var items: [URLQueryItem] = []
            if let location { items.append(.init(name: "location", value: location)) }
            if let date { items.append(.init(name: "date", value: date)) }
            if let fields { items.append(.init(name: "fields", value: fields.joined(separator: ","))) }
            return items
        case .locations: return []
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
