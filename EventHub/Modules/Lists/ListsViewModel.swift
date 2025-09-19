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
    
    func load() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            self.items = try await DataManager.shared.fetchLists()
        } catch {
            self.errorText = error.localizedDescription
        }
    }
}
