//
//  DataManager.swift
//  EventHub
//
//  Created by Наташа Спиридонова on 08.09.2025.
//

import Foundation

// MARK: - DataManager
final class DataManager {
    // MARK: - Свойства
    static let shared = DataManager()
    private let client = SimpleClient()
    
    // MARK: - Инициализация
    private init() {}
    
    // MARK: - Категории
    func fetchEventCategories() async throws -> [EventCategory] {
        return try await client.fetch(.eventCategories(fields: ["id", "slug", "name"]))
    }
    
    func fetchPlaceCategories() async throws -> [PlaceCategory] {
        try await client.fetch(.placeCategories(fields: ["id", "slug", "name"]))
    }
    
    // MARK: - Агенты и роли
    func fetchAgents(page: Int? = nil) async throws -> [Agent] {
        let response: PagedResponse<Agent> = try await client.fetch(
            .agents(page: page, fields: ["id", "title", "slug"])
        )
        return response.results
    }

    func fetchAgentRoles() async throws -> [AgentRole] {
        let page: PagedResponse<AgentRole> = try await client.fetch(.agentRoles())
        return page.results
    }

    // MARK: - События
    func fetchEvents(location: String, actualSince: Int, actualUntil: Int) async throws -> [EventItem] {
        let page: PagedResponse<EventItem> = try await client.fetch(.events(location: location, since: actualSince, until: actualUntil))
        return page.results
    }
    
    func fetchEventsOfTheDay(location: String? = nil, date: String? = nil) async throws -> [EventOfTheDay] {
        let response: PagedResponse<EventOfTheDay> = try await client.fetch(
            .eventsOfTheDay(location: location, date: date, fields: ["date", "location", "object", "title"])
        )
        return response.results
    }
    
    // MARK: - Новости
    func fetchNews(page: Int? = nil) async throws -> [NewsItem] {
        let response: PagedResponse<NewsItem> = try await client.fetch(
            .news(page: page, fields: ["id", "publication_date", "title", "slug"])
        )
        return response.results
    }
    
    // MARK: - Подборки
    func fetchLists(page: Int? = nil) async throws -> [ListItem] {
        let response: PagedResponse<ListItem> = try await client.fetch(
            .lists(page: page, fields: ["id", "publication_date", "title", "slug", "site_url"])
        )
        return response.results
    }
    
    // MARK: - Места
    func fetchPlaces(page: Int? = nil) async throws -> [Place] {
        let response: PagedResponse<Place> = try await client.fetch(
            .places(page: page, fields: ["id", "title", "slug", "address", "phone", "site_url", "subway", "is_closed", "location", "has_parking_lot"])
        )
        return response.results
    }
}
