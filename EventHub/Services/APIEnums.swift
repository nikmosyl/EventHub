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
    case search(filters: EventFilters, query: String, lat: Double? = nil, lon: Double? = nil, radius: Int? = nil, page: Int? = nil)

    // MARK: - Путь запроса
    var path: String {
        return switch self {
        case .eventCategories: "event-categories/"
        case .events: "events/"
        case .lists: "lists/"
        case .locations: "locations/"
        case .movies: "movies/"
        case .search: "search/"
        }
    }

    // MARK: - Параметры запроса
    var query: [URLQueryItem] {
            switch self {
            case .eventCategories, .locations:
                return []
                
            case .search(let filters, let query, let lat, let lon, let radius, let page):
                print("это сёрч")
                var items: [URLQueryItem] = []
                items.append(.init(name: "q", value: String(query)))
                if let lat = lat {
                    items.append(.init(name: "lat", value: String(lat)))
                }
                if let lon = lon {
                    items.append(.init(name: "lon", value: String(lon)))
                }
                if let radius = radius {
                    items.append(.init(name: "radius", value: String(radius)))
                }
                if let page = page {
                    items.append(.init(name: "page", value: String(page)))
                }
                items += filters.toQueryItems()
                return items
                
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
        if let ctype = ctype {
            items.append(.init(name: "ctype", value: ctype))
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
        if let lon = lon {
            items.append(.init(name: "lon", value: String(lon)))
        }
        if let lat = lat {
            items.append(.init(name: "lat", value: String(lat)))
        }
        if let radius = radius {
            items.append(.init(name: "radius", value: String(radius)))
        }
        
        return items
    }
}
