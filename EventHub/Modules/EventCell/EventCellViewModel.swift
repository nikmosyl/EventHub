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
    private(set) var event: Event
    
    init(event: Event) {
        self.event = event
        loadBookmarkStatus()
    }
    
    // изображение
    var imageURL: String? {
        event.images?.first(where: { $0.image != nil })?.image
    }
    
    // дата и время
    var dateTime: String {
        if let nextDate = event.nextDate, let start = nextDate.start {
            return nextDate.formatter(date: start, format: "E, dd MMM • HH:mm")
        }
        if let previousDate = event.previousDate, let start = previousDate.start {
            return previousDate.formatter(date: start, format: "E, dd MMM • HH:mm")
        }
        
        return "Date not specified"
    }
    
    // название мероприятия
    var title: String {
        event.title ?? event.shortTitle ?? "Empty title"
    }
    
    // место и город
    var location: String {
        let venue = event.place?.title ?? "Address not specified"
        
        if let city = event.location?.name {
            return "\(city) • \(venue)"
        }
        
        if let citySlug = event.location?.slug,
           let cityName = getCityName(for: citySlug) {
            return "\(cityName) • \(venue)"
        }
        
        if let citySlug = event.place?.location,
           let cityName = getCityName(for: citySlug) {
            return "\(cityName) • \(venue)"
        }
        
        return venue
    }
    
    func loadBookmarkStatus() {
        Task {
            if let id = event.id {
                isBookmarked = await dataManager.isEventBookmarked(eventId: id)
            }
        }
    }
    
    func onAppear() {
        loadBookmarkStatus()
    }
    
    func toggleBookmark() {
        guard !isLoading else { return }
        
        isLoading = true
        
        Task {
            do {
                if let id = event.id {
                    if isBookmarked {
                        try await dataManager.removeFromBookmarks(eventId: id)
                    } else {
                        try await dataManager.addToBookmarks(eventId: id)
                    }
                    
                    isBookmarked.toggle()
                }
                
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
            return "Moscow"
        case "spb":
            return "Saint Petersburg"
        case "ekb":
            return "Yekaterinburg"
        case "kzn":
            return "Казань"
        case "nnv":
            return "Kazan"
        default:
            return nil
        }
    }
}
