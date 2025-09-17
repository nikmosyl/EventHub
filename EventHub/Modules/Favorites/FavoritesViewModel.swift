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
    @Published var favoritesState: FavoritesViewState = .empty
    @Published var searchText: String = ""
    @Published var isSearching: Bool = false

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
                let favoriteIds: [Int] = DataManager.shared.getFavoritesIds()
                
                let favorites: [Event] = try await DataManager.shared.getEventsByIds(ids: favoriteIds)

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

    func toggleSearch() {
        isSearching.toggle()
        if !isSearching {
            searchText = ""
        }
    }

    func searchFavorites() {
        guard !searchText.isEmpty else {
            favoritesState = favoriteEvents.isEmpty ? .empty : .loaded(favoriteEvents)
            return
        }

        let filteredEvents = favoriteEvents.filter { event in
            event.title?.localizedCaseInsensitiveContains(searchText) ?? false
        }

        favoritesState = filteredEvents.isEmpty ? .empty : .loaded(filteredEvents)
    }
}

