//
//  FavoritesViewModel.swift
//  EventHub
//
//  Created by Николай Игнатов on 15.09.2025.
//

import Foundation

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published var favoriteEvents: [Event] = []
    @Published var favoritesState: FavoritesViewState = .initial

    private let dataManager = DataManager.shared

    init() {
        loadFavorites()
    }

    func loadFavorites() {
        favoritesState = .loading

        Task {
            do {
                // TODO: Implement favorites storage and retrieval
                // For now, return empty array
                let favorites: [Event] = []

                if favorites.isEmpty {
                    favoritesState = .empty
                } else {
                    favoriteEvents = favorites
                    favoritesState = .loaded(favorites)
                }
            } catch {
                let message = "Failed to load favorites: \(error.localizedDescription)"
                favoritesState = .error(message)
            }
        }
    }

    func toggleFavorite(event: Event) {
        // TODO: Implement favorite toggle logic
        print("Toggle favorite for event: \(event.title)")
    }

    func removeFavorite(event: Event) {
        // TODO: Implement remove favorite logic
        favoriteEvents.removeAll { $0.id == event.id }

        if favoriteEvents.isEmpty {
            favoritesState = .empty
        } else {
            favoritesState = .loaded(favoriteEvents)
        }
    }
}
