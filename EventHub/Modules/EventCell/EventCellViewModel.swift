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
    private var event: Event?
    
    init(event: Event) {
        self.event = event
        loadBookmarkStatus()
    }
    
    var imageURL: URL? {
        guard let firstImage = event?.images?.first?.image else {
            return nil
        }
        return URL(string: firstImage)
    }
    
    var dateTime: String {
        if let startTimestamp = event?.dates?.first?.start {
            let startDate = Date(timeIntervalSince1970: TimeInterval(startTimestamp))
            let dateString = startDate.formatted(date: .abbreviated, time: .omitted)
            let timeString = startDate.formatted(date: .omitted, time: .shortened)
            return "\(dateString) • \(timeString)"
        }
        
        return "Дата не указана"
    }
    
    var title: String {
        event?.title ?? "Название неизвестно"
    }
    
    var location: String {
        var locationParts: [String] = []
        
        if let venue = event?.place?.title {
            locationParts.append(venue)
        }
        
        if let city = event?.location?.name {
            locationParts.append(city)
        }
        
        return locationParts.isEmpty ? "Место не указано" : locationParts.joined(separator: " • ")
    }
    
    func loadBookmarkStatus() {
        Task {
            isBookmarked = await dataManager.isEventFavorite(eventId: event?.id ?? 0)
        }
    }
    
    func toggleBookmark() {
        guard !isLoading else { return }
        
        isLoading = true
        
        Task {
            do {
                if isBookmarked {
                    try await dataManager.removeFromFavorites(eventId: event?.id ?? 0)
                } else {
                    try await dataManager.addToFavorites(eventId: event?.id ?? 0)
                }
                
                isBookmarked.toggle()
                isLoading = false
            } catch {
                isLoading = false
                print("Ошибка при изменении избранного: \(error)")
            }
        }
    }
}
