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
    
    func fetchEventCategories() async throws -> [EventCategory] {
        return try await client.fetch(.eventCategories(fields: ["id", "slug", "name"]))
    }
    
    func fetchPlaceCategories() async throws -> [PlaceCategory] {
        try await client.fetch(.placeCategories(fields: ["id", "slug", "name"]))
    }
    
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
}
