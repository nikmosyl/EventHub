//
//  ProButtonsViewModel.swift
//  EventHub
//
//  Created by Drolllted on 22.09.2025.
//

import Foundation

final class ProButtonsViewModel: ObservableObject {
    
    @Published var todayEvents = [Event]()
    @Published var filmsEvents = [Event]()
    @Published var ListsEvents = [Event]()
    
    private let dataManager = DataManager.shared
    
    //MARK: - Фильтр для определенного дня
    func filterTodayEvents(from events: [Event]) -> [Event] {
        let calendar = Calendar.current
        let today = Date()
        
        return events.filter { event in
            guard let eventDate = event.dates?.first,
                  let startTimestamp = eventDate.start else {
                return false
            }
            
            let eventStartDate = Date(timeIntervalSince1970: TimeInterval(startTimestamp))
            return calendar.isDate(eventStartDate, inSameDayAs: today)
        }
    }
    
    // Фильтрация фильмов
    func filterFilms(from events: [Event]) -> [Event] {
        return events.filter { event in
            event.categories?.contains("films") == true ||
            event.categories?.contains("cinema") == true ||
            event.title?.lowercased().contains("film") == true ||
            event.title?.lowercased().contains("movie") == true ||
            event.categories?.contains("кино") == true ||
            event.categories?.contains("фильм") == true
        }
    }
    
    // Получение списков (подборок)
    func fetchLists() async throws -> [ListItem] {
        return try await dataManager.fetchLists()
    }
    
}
