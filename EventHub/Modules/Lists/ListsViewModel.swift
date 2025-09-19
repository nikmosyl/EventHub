//
//  ListsViewModel.swift
//  EventHub
//
//  Created by Наташа Спиридонова on 19.09.2025.
//

import Foundation

@MainActor
final class ListsViewModel: ObservableObject {
    @Published private(set) var items: [ListItem] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorText: String?
    
    private var allItems: [ListItem] = []
    
    func load() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            let newItems = try await DataManager.shared.fetchLists()
            self.items = newItems
            self.allItems = newItems
        } catch {
            self.errorText = error.localizedDescription
        }
    }
    
    func search(query: String) async {
        guard !query.isEmpty else {
            self.items = allItems
            return
        }
        
        let filtered = items.filter { item in
            item.title?.localizedCaseInsensitiveContains(query) == true
        }
        
        self.items = filtered
    }
    
    func clearSearch() async {
        self.items = allItems
    }
}
