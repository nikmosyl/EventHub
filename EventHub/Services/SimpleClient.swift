//
//  SimpleClient.swift
//  EventHub
//
//  Created by Наташа Спиридонова on 08.09.2025.
//


import Foundation

// MARK: - Ошибки сети
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case badStatus(Int)
    case decoding(Error)
}

// MARK: - Описание запросов
enum APIRequest {
    case eventCategories(
        fields: [String]? = nil
    )
    case placeCategories(
        fields: [String]? = nil
    )
    case agents(
        page: Int? = nil,
        fields: [String]? = nil
    )
    case agentRoles(
        lang: String = "ru",
        fields: [String] = ["id", "name", "name_plural"]
    )
    case events(
        location: String,
        since: Int,
        until: Int,
        pageSize: Int = 20,
        fields: [String] = ["id","title","dates"]
    )
    case eventsOfTheDay(
        location: String? = nil,
        date: String? = nil,
        fields: [String]? = nil
    )

    var path: String {
        switch self {
        case .eventCategories: return "event-categories/"
        case .placeCategories: return "place-categories/"
        case .agents: return "agents/"
        case .agentRoles: return "agent-roles/"
        case .events: return "events/"
        case .eventsOfTheDay: return "events-of-the-day/"
        }
    }

    var query: [URLQueryItem] {
        switch self {
        case let .eventCategories(fields):
            var items: [URLQueryItem] = []
            if let fields, !fields.isEmpty {
                items.append(.init(name: "fields", value: fields.joined(separator: ",")))
            }
            return items
            
        case let .placeCategories(fields):
            var items: [URLQueryItem] = []
            if let fields, !fields.isEmpty {
                items.append(.init(name: "fields", value: fields.joined(separator: ",")))
            }
            return items
            
        case let .agents(page, fields):
            var items: [URLQueryItem] = []
            if let page { items.append(.init(name: "page", value: String(page))) }
            if let fields, !fields.isEmpty {
                items.append(.init(name: "fields", value: fields.joined(separator: ",")))
            }
            return items
            
        case let .agentRoles(lang, fields):
            return [
                .init(name: "lang", value: lang),
                .init(name: "fields", value: fields.joined(separator: ","))
            ]
            
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
            if let date { items.append(.init(name: "date", value: date)) } // формат YYYY-MM-DD
            if let fields, !fields.isEmpty {
                items.append(.init(name: "fields", value: fields.joined(separator: ",")))
            }
            return items
        }
    }

    func urlRequest(baseURL: URL) throws -> URLRequest {
        var components = URLComponents(
            url: baseURL.appendingPathComponent(path),
            resolvingAgainstBaseURL: false
        )
        components?.queryItems = query
        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}


final class SimpleClient {
    private let baseURL = URL(string: "https://kudago.com/public-api/v1.4")!
    private let session: URLSession
    private let decoder: JSONDecoder
    private let maxRetries: Int = 1

    init(session: URLSession = .shared) {
        self.session = session
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        self.decoder = decoder
    }

    func fetch<T: Decodable>(_ request: APIRequest) async throws -> T {
        let urlRequest = try request.urlRequest(baseURL: baseURL)
        var lastError: Error?
        for attempt in 0...maxRetries {
            do {
                let (data, response) = try await session.data(for: urlRequest)
                return try validateAndDecode(data: data, response: response)
            } catch {
                lastError = error
                if attempt == maxRetries { break }
                // Небольшая задержка перед повтором
                try? await Task.sleep(nanoseconds: 200_000_000)
            }
        }
        throw lastError ?? NetworkError.invalidResponse
    }

    // MARK: - Валидация и декодирование
    private func validateAndDecode<T: Decodable>(data: Data, response: URLResponse) throws -> T {
        guard let http = response as? HTTPURLResponse else { throw NetworkError.invalidResponse }
        guard (200...299).contains(http.statusCode) else { throw NetworkError.badStatus(http.statusCode) }
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decoding(error)
        }
    }
}
