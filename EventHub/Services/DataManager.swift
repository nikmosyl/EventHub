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
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        
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
    func fetchEventCategories() async throws -> [EventCategory] {
        try await fetchSimple(.eventCategories)
    }
    
    // MARK: - Получение категорий мест
    func fetchPlaceCategories() async throws -> [PlaceCategory] {
        try await fetchSimple(.placeCategories)
    }
    
    // MARK: - Получение агентов
    func fetchAgents(page: Int? = nil) async throws -> [Agent] {
        try await fetchPaged(.agents(page: page))
    }
    
    // MARK: - Получение ролей агентов
    func fetchAgentRoles() async throws -> [AgentRole] {
        try await fetchPaged(.agentRoles())
    }
    
    // MARK: - Получение событий с фильтрами
    func fetchEvents(filters: EventFilters) async throws -> [EventItem] {
        try await fetchPaged(.events(filters: filters))
    }
    
    // MARK: - Получение событий (обратная совместимость)
    func fetchEvents(location: String, actualSince: Int, actualUntil: Int, page: Int? = nil) async throws -> [EventItem] {
        let filters = EventFilters(
            location: location,
            actualSince: actualSince,
            actualUntil: actualUntil,
            page: page
        )
        return try await fetchEvents(filters: filters)
    }
    
    // MARK: - Получение событий дня
    func fetchEventsOfTheDay(location: String? = nil, date: String? = nil) async throws -> [EventOfTheDay] {
        try await fetchPaged(.eventsOfTheDay(location: location, date: date))
    }
    
    // MARK: - Получение всех событий с фильтрами
    func fetchAllEvents(filters: EventFilters) async throws -> [EventItem] {
        var all: [EventItem] = []
        var page: Int? = 1
        
        while let currentPage = page {
            let updatedFilters = EventFilters(
                location: filters.location,
                actualSince: filters.actualSince,
                actualUntil: filters.actualUntil,
                categories: filters.categories,
                isFree: filters.isFree,
                price: filters.price,
                ageRestriction: filters.ageRestriction,
                tags: filters.tags,
                search: filters.search,
                page: currentPage,
                pageSize: filters.pageSize ?? 100
            )
            
            let response: PagedResponse<EventItem> = try await fetch(.events(filters: updatedFilters))
            all.append(contentsOf: response.results)
            page = URLComponents(string: response.next ?? "")?
                .queryItems?.first(where: { $0.name == "page" })?.value
                .flatMap(Int.init)
        }
        
        return all
    }
    
    // MARK: - Получение всех событий (обратная совместимость)
    func fetchAllEvents(location: String, actualSince: Int, actualUntil: Int) async throws -> [EventItem] {
        let filters = EventFilters(
            location: location,
            actualSince: actualSince,
            actualUntil: actualUntil
        )
        return try await fetchAllEvents(filters: filters)
    }
    
    // MARK: - Получение новостей
    func fetchNews(page: Int? = nil) async throws -> [NewsItem] {
        try await fetchPaged(.news(page: page))
    }
    
    // MARK: - Получение подборок
    func fetchLists(page: Int? = nil) async throws -> [ListItem] {
        try await fetchPaged(.lists(page: page))
    }
    
    // MARK: - Получение мест
    func fetchPlaces(page: Int? = nil) async throws -> [Place] {
        try await fetchPaged(.places(page: page))
    }
    
    // MARK: - Получение локаций
    func fetchLocations() async throws -> [Location] {
        try await fetchSimple(.locations)
    }
    
    // MARK: - Получение показов фильмов
    func fetchMovieShowings(page: Int? = nil) async throws -> [MovieShowing] {
        try await fetchPaged(.movieShowings(page: page))
    }
    
    // MARK: - Получение фильмов
    func fetchMovies(page: Int? = nil) async throws -> [Movie] {
        try await fetchPaged(.movies(page: page))
    }
    
    // MARK: - Получение детальной информации о событии
    func fetchEventDetails(eventId: Int) async throws -> EventDetails {
        try await fetchSimple(.eventDetails(id: eventId))
    }
    
    // MARK: - Методы для создания фильтров
    
    /// Поиск событий по тексту
    func searchEvents(query: String, location: String? = nil, page: Int? = nil) async throws -> [EventItem] {
        let filters = EventFilters(
            location: location,
            search: query,
            page: page
        )
        return try await fetchEvents(filters: filters)
    }
    
    /// События по категории
    func fetchEventsByCategory(category: String, location: String? = nil, page: Int? = nil) async throws -> [EventItem] {
        let filters = EventFilters(
            location: location,
            categories: [category],
            page: page
        )
        return try await fetchEvents(filters: filters)
    }
    
    /// Бесплатные события
    func fetchFreeEvents(location: String? = nil, page: Int? = nil) async throws -> [EventItem] {
        let filters = EventFilters(
            location: location,
            isFree: true,
            page: page
        )
        return try await fetchEvents(filters: filters)
    }
    
    /// События по датам
    func fetchEventsByDateRange(
        location: String,
        from: Date,
        to: Date,
        page: Int? = nil
    ) async throws -> [EventItem] {
        let filters = EventFilters(
            location: location,
            actualSince: Int(from.timeIntervalSince1970),
            actualUntil: Int(to.timeIntervalSince1970),
            page: page
        )
        return try await fetchEvents(filters: filters)
    }
    
    /// События по тегам
    func fetchEventsByTags(tags: [String], location: String? = nil, page: Int? = nil) async throws -> [EventItem] {
        let filters = EventFilters(
            location: location,
            tags: tags,
            page: page
        )
        return try await fetchEvents(filters: filters)
    }
}
