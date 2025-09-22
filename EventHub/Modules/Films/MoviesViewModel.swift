//
//  MoviesViewModel.swift
//  EventHub
//
//  Created by Наташа Спиридонова on 22.09.2025.
//

import Foundation

@MainActor
final class MoviesViewModel: ObservableObject {
    @Published private(set) var items: [Movie] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorText: String?
    
    func load() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            let newItems = try await DataManager.shared.fetchMovies()
            self.items = newItems
        } catch {
            self.errorText = error.localizedDescription
        }
    }
    
    func processedTitle(for item: Movie) -> String {
        item.title ?? "Unknown title"
    }
    
    func processedPoster(for item: Movie) -> String {
        item.poster?.image ?? ""
    }
}
