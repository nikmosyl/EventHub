//
//  EventCellViewModel.swift
//  EventHub
//
//  Created by Наташа Спиридонова on 14.09.2025.
//

import Foundation

@MainActor
final class EventCellViewModel: ObservableObject {
    @Published var isBookmarked = false
    @Published var isLoading = false
    
    private let dataManager = DataManager.shared
    private var event: Event
    
    init(event: Event) {
        self.event = event
        loadBookmarkStatus()
    }
    
    // изображение
    var imageURL: String? {
        event.images?.first?.image
    }
    
    // дата и время
    var dateTime: String {
        if let startTimestamp = event.dates?.first?.start {
            let startDate = Date(timeIntervalSince1970: TimeInterval(startTimestamp))
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.dateFormat = "E, dd MMM • HH:mm"
            
            return formatter.string(from: startDate)
        }
        
        return "Дата не указана"
    }
    
    // название мероприятия
    var title: String {
        event.title
    }
    
    // место и город
    var location: String {
        let venue = event.place?.title ?? "Место не указано"
        
        if let citySlug = event.location?.slug,
           let cityName = getCityName(for: citySlug) {
            return "\(venue) • \(cityName)"
        } else {
            return venue
        }
    }
    
    func loadBookmarkStatus() {
        Task {
            isBookmarked = await dataManager.isEventFavorite(eventId: event.id ?? 0)
        }
    }
    
    func toggleBookmark() {
        guard !isLoading else { return }
        
        isLoading = true
        
        Task {
            do {
                if isBookmarked {
                    try await dataManager.removeFromFavorites(eventId: event.id ?? 0)
                } else {
                    try await dataManager.addToFavorites(eventId: event.id ?? 0)
                }
                
                isBookmarked.toggle()
                isLoading = false
            } catch {
                isLoading = false
                print("Ошибка при изменении избранного: \(error)")
            }
        }
    }
    
    private func getCityName(for slug: String) -> String? {
        switch slug {
        case "msk":
            return "Москва"
        case "spb":
            return "Санкт-Петербург"
        case "ekb":
            return "Екатеринбург"
        case "kzn":
            return "Казань"
        case "nnv":
            return "Нижний Новгород"
        default:
            return "Такого города нет"
        }
    }
}
