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
    @Published var navigateToSearch: Bool = false
    
    var previousIds: [Int] = []

    private let dataManager = DataManager.shared

    func loadFavorites() {
        favoritesState = .loading
        
        Task {
            do {
                let favoriteIds: [Int] = try await DataManager.shared.getFavoritesIds()
                
                if favoriteIds.isEmpty {
                    favoritesState = .empty
                    return
                }
                
                if previousIds == favoriteIds {
                    favoritesState = .loaded
                    return
                }
                
                previousIds = favoriteIds
                let favorites: [Event] = try await DataManager.shared.getEventsByIds(ids: favoriteIds)

                if favorites.isEmpty {
                    favoritesState = .empty
                } else {
                    favoriteEvents = favorites
                    favoritesState = .loaded
                }
            } catch {
                let message = "Failed to load favorites: \(error.localizedDescription)"
                favoritesState = .error(message)
            }
        }
    }
}

