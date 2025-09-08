//
//  DataManager.swift
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

// MARK: - Ошибки сети
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case badStatus(Int)
    case decoding(Error)
}

// MARK: - Описание запросов
enum APIRequest {
    case agentRoles(lang: String = "ru", fields: [String] = ["id", "name", "name_plural"])
    case events(location: String, since: Int, until: Int, pageSize: Int = 20, fields: [String] = ["id","title","dates"])

    var path: String {
        switch self {
        case .agentRoles: return "agent-roles/"
        case .events: return "events/"
        }
    }

    var query: [URLQueryItem] {
        switch self {
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
        }
    }

    func urlRequest(baseURL: URL) throws -> URLRequest {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        components?.queryItems = query
        guard let url = components?.url else { throw NetworkError.invalidURL }
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        return req
    }
}

// MARK: - Клиент (минималистичный)
final class SimpleClient {
    private let baseURL = URL(string: "https://kudago.com/public-api/v1.4")!
    private let session: URLSession
    private let decoder: JSONDecoder
    private let maxRetries: Int = 1

    init(session: URLSession = .shared) {
        self.session = session
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        d.dateDecodingStrategy = .secondsSince1970
        self.decoder = d
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
        do { return try decoder.decode(T.self, from: data) }
        catch { throw NetworkError.decoding(error) }
    }
}

// MARK: - Модели
struct AgentRole: Decodable, Sendable {
    let id: Int
    let name: String?
    let namePlural: String?
}

struct EventItem: Decodable, Sendable {
    let id: Int
    let title: String
    let dates: [EventDate]?
}

struct EventDate: Decodable, Sendable {
    let start: Int?
    let end: Int?
    let startDate: String?
    let endDate: String?
    let startTime: String?
    let endTime: String?
}

// MARK: - Пример использования в DataManager
final class DataManager {
    static let shared = DataManager()
    private let client = SimpleClient()

    func fetchAgentRoles() async throws -> [AgentRole] {
        let page: PagedResponse<AgentRole> = try await client.fetch(.agentRoles())
        return page.results
    }

    func fetchEvents(location: String, actualSince: Int, actualUntil: Int) async throws -> [EventItem] {
        let page: PagedResponse<EventItem> = try await client.fetch(.events(location: location, since: actualSince, until: actualUntil))
        return page.results
    }
}
