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
    case events(filters: EventFilters, id: Int? = nil)
    case lists(page: Int? = nil)
    case locations
    case movies(page: Int? = nil)

    // MARK: - Путь запроса
    var path: String {
        switch self {
        case .eventCategories: return "event-categories/"
        case .events: return "events/"
        case .lists: return "lists/"
        case .locations: return "locations/"
        case .movies: return "movies/"
        }
    }

    // MARK: - Параметры запроса
    var query: [URLQueryItem] {
            switch self {
            case .eventCategories, .locations:
                return []
                
            case .events(let filters, _):
                return filters.toQueryItems()
                
            case .lists(let page), .movies(let page):
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

// MARK: - Расширение EventFilters
extension EventFilters {
    func toQueryItems() -> [URLQueryItem] {
        var items: [URLQueryItem] = []
        
        if let location = location {
            items.append(.init(name: "location", value: location))
        }
        if let actualSince = actualSince {
            items.append(.init(name: "actual_since", value: String(actualSince)))
        }
        if let actualUntil = actualUntil {
            items.append(.init(name: "actual_until", value: String(actualUntil)))
        }
        if let categories = categories, !categories.isEmpty {
            items.append(.init(name: "categories", value: categories.joined(separator: ",")))
        }
        if let search = search {
            items.append(.init(name: "search", value: search))
        }
        if let page = page {
            items.append(.init(name: "page", value: String(page)))
        }
        if let pageSize = pageSize {
            items.append(.init(name: "page_size", value: String(pageSize)))
        }
        if let fields = fields, !fields.isEmpty {
            items.append(.init(name: "fields", value: fields.joined(separator: ",")))
        }
        if let expand = expand, !expand.isEmpty {
            items.append(.init(name: "expand", value: expand.joined(separator: ",")))
        }
        if let ids = ids {
            items.append(.init(name: "ids", value: String(ids)))
        }
        
        return items
    }
}
