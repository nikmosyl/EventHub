//
//  EventCardViewModel.swift
//  EventHub
//
//  Created by Drolllted on 20.09.2025.
//

import Foundation

@MainActor
final class EventCardViewModel: ObservableObject {
    
    @Published var isLiked: Bool = false
    @Published var favoriteEventIds: Set<Int> = []
    
    private let dataManager = DataManager.shared
    private let event: Event
    
    init(event: Event) {
        self.event = event
        loadInitialFavoriteStatus()
    }
    
    // MARK: - Public Methods
    
    func eventsToggle() {
        Task {
            guard let eventId = event.id else { return }
            
            do {
                if isEventFavorited(eventId: eventId) {
                    try await dataManager.removeFromFavorites(eventId: eventId)
                    favoriteEventIds.remove(eventId)
                    isLiked = false
                } else {
                    try await dataManager.addToFavorites(eventId: eventId)
                    favoriteEventIds.insert(eventId)
                    isLiked = true
                }
                
            } catch {
                print("Ошибка при изменении избранного: \(error.localizedDescription)")
            }
        }
    }
    
    func checkIfEventIsFavorited() async -> Bool {
        guard let eventId = event.id else { return false }
        return await dataManager.isEventfavorited(eventId: eventId)
    }
    
    func isEventFavorited(eventId: Int) -> Bool {
        return favoriteEventIds.contains(eventId)
    }
    
    // MARK: - Private Methods
    
    private func loadInitialFavoriteStatus() {
        Task {
            guard let eventId = event.id else { return }
            let isFavorited = await dataManager.isEventfavorited(eventId: eventId)
            await MainActor.run {
                isLiked = isFavorited
                if isFavorited {
                    favoriteEventIds.insert(eventId)
                }
            }
        }
    }
}
