//
//  Models.swift
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

// MARK: - Модели
struct EventCategory: Decodable, Sendable {
    let id: Int
    let slug: String
    let name: String
}

struct PlaceCategory: Decodable, Sendable {
    let id: Int
    let slug: String
    let name: String
}

struct Agent: Decodable, Sendable {
    let id: Int
    let title: String
    let slug: String
}

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

// MARK: - Событие дня
struct EventOfTheDay: Decodable, Sendable {
    let date: String
    let location: String
    let object: EventOfTheDayObject
    let title: String

    struct EventOfTheDayObject: Decodable, Sendable {
        let id: Int
        let ctype: String
    }
}
