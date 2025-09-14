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
    private init() {}
    
    // MARK: - Универсальный запрос
    private func fetch<T: Decodable>(_ request: APIRequest) async throws -> T {
        
#warning("убрать Debug")
        print("request.urlRequest():", try request.urlRequest())
        
        let (data, response) = try await URLSession.shared.data(for: try request.urlRequest())
        
        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(http.statusCode) else {
            throw NetworkError.badStatus(http.statusCode)
        }
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        formatter.dateFormat = "y-MM-dd"
        formatter.locale = Locale(identifier: "en_US")
        formatter.timeZone = TimeZone(identifier: "UTC")
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decoding(error)
        }
    }
    
    // MARK: - Универсальные методы
    private func fetchPaged<T: Decodable>(_ request: APIRequest) async throws -> [T] {
        let response: PagedResponse<T> = try await fetch(request)
        return response.results
    }
    
    private func fetchSimple<T: Decodable>(_ request: APIRequest) async throws -> T {
        return try await fetch(request)
    }
    
    // MARK: - Получение категорий событий
    private func fetchEventCategories() async throws -> [EventCategory] {
        try await fetchSimple(.eventCategories)
    }
    
    // MARK: - Получение событий с фильтрами
    private func fetchEvents(filters: EventFilters = EventFilters(), id: Int? = nil) async throws -> [Event] {
        let updatedFilters = EventFilters(
            location: filters.location,
            actualSince: filters.actualSince,
            actualUntil: filters.actualUntil,
            categories: filters.categories,
            search: filters.search,
            page: filters.page,
            price: filters.price,
            fields: filters.fields ?? [
                "id",
                "title",
                "slug",
                "description",
                "short_title",
                "dates",
                "location",
                "images",
                "categories",
                "favorites_count",
                "place"
            ],
            expand: filters.expand ?? [
                "place"
            ]
        )
        return try await fetchPaged(.events(filters: updatedFilters, id: id))
    }
    
    // MARK: - Получение одного события по ID
    private func fetchEvent(id: Int) async throws -> Event {
        let events = try await fetchEvents(id: id)
        guard let event = events.first else {
            throw NetworkError.invalidResponse
        }
        return event
    }
    
    // MARK: - Получение подборок
    private func fetchLists(page: Int? = nil) async throws -> [ListItem] {
        try await fetchPaged(.lists(page: page))
    }
    
    // MARK: - Получение локаций
    private func fetchLocations() async throws -> [Location] {
        try await fetchSimple(.locations)
    }
    
    // MARK: - Получение фильмов
    private func fetchMovies(page: Int? = nil) async throws -> [Movie] {
        try await fetchPaged(.movies(page: page))
    }
    
    
    // MARK: - Поиск событий по тексту
    func searchEvents(query: String, location: String? = nil, page: Int? = nil) async throws -> [Event] {
        let filters = EventFilters(
            location: location,
            search: query,
            page: page
        )
        return try await fetchEvents(filters: filters)
    }
    
    func getUpcamingEvents(categories: [String]? = nil) async throws -> [Event] {
        let actualSince = Int(Date().timeIntervalSince1970)
        let actualUntil = actualSince + (7 * 24 * 60 * 60)
        
        let filters = EventFilters(
            actualSince: actualSince,
            actualUntil: actualUntil,
            categories: categories
        )
        return try await fetchEvents(filters: filters)
    }
    
    func getNearByEvents(location: String, categories: [String]? = nil) async throws -> [Event] {
        let filters = EventFilters(
            location: location,
            categories: categories
        )
        return try await fetchEvents(filters: filters)
    }
    
    func getCategories() async throws -> [EventCategory] {
        try await fetchEventCategories()
    }
    
    func getLocations() async throws -> [Location] {
        try await fetchLocations()
    }
}

// MARK: - DataManager + Избранное
extension DataManager {
    
    // Добавление в избранное
    func addToFavorites(eventId: Int) async throws {
        print("Добавляем событие \(eventId) в избранное")
        
        try await Task.sleep(nanoseconds: 500_000_000)
    }
    
    // Удаление из избранного
    func removeFromFavorites(eventId: Int) async throws {
        print("Удаляем событие \(eventId) из избранного")
        
        try await Task.sleep(nanoseconds: 500_000_000)
    }
    
    // Проверка статуса избранного
    func isEventFavorite(eventId: Int) async -> Bool {
        return false
    }
    
    // Получение всех избранных событий
    func getFavoriteEvents() async throws -> [Event] {
        return []
    }
}
