//
//  DataManager.swift
//  EventHub
//
//  Created by Наташа Спиридонова on 08.09.2025.
//

import Foundation

// MARK: - DataManager
final class DataManager {
    static let shared = DataManager()
    private let client = SimpleClient()
    private init() {}
    
    // MARK: - Универсальные методы
    private func fetchPaged<T: Decodable>(_ request: APIRequest) async throws -> [T] {
        let response: PagedResponse<T> = try await client.fetch(request)
        return response.results
    }
    
    private func fetchSimple<T: Decodable>(_ request: APIRequest) async throws -> T {
        return try await client.fetch(request)
    }
    
    // MARK: - Получение категорий событий
    func fetchEventCategories() async throws -> [EventCategory] {
        try await fetchSimple(.eventCategories(fields: APIFields.category))
    }
    
    // MARK: - Получение категорий мест
    func fetchPlaceCategories() async throws -> [PlaceCategory] {
        try await fetchSimple(.placeCategories(fields: APIFields.category))
    }
    
    // MARK: - Получение агентов
    func fetchAgents(page: Int? = nil) async throws -> [Agent] {
        try await fetchPaged(.agents(page: page, fields: APIFields.basic))
    }

    // MARK: - Получение ролей агентов
    func fetchAgentRoles() async throws -> [AgentRole] {
        try await fetchPaged(.agentRoles())
    }

    // MARK: - Получение событий
    func fetchEvents(location: String, actualSince: Int, actualUntil: Int) async throws -> [EventItem] {
        try await fetchPaged(.events(location: location, since: actualSince, until: actualUntil))
    }
    
    // MARK: - Получение событий дня
    func fetchEventsOfTheDay(location: String? = nil, date: String? = nil) async throws -> [EventOfTheDay] {
        try await fetchPaged(.eventsOfTheDay(location: location, date: date, fields: APIFields.eventOfTheDay))
    }
    
    // MARK: - Получение новостей
    func fetchNews(page: Int? = nil) async throws -> [NewsItem] {
        try await fetchPaged(.news(page: page, fields: APIFields.news))
    }
    
    // MARK: - Получение подборок
    func fetchLists(page: Int? = nil) async throws -> [ListItem] {
        try await fetchPaged(.lists(page: page, fields: APIFields.news))
    }
    
    // MARK: - Получение мест
    func fetchPlaces(page: Int? = nil) async throws -> [Place] {
        try await fetchPaged(.places(page: page, fields: APIFields.place))
    }

    // MARK: - Получение локаций
    func fetchLocations() async throws -> [Location] {
        try await fetchSimple(.locations)
    }
    
    // MARK: - Получение показов фильмов
    func fetchMovieShowings(page: Int? = nil) async throws -> [MovieShowing] {
        try await fetchPaged(.movieShowings(page: page, fields: APIFields.movieShowing))
    }
    
    // MARK: - Получение фильмов
    func fetchMovies(page: Int? = nil) async throws -> [Movie] {
        try await fetchPaged(.movies(page: page, fields: APIFields.movie))
    }
}
