//
//  SearchViewModel.swift
//  EventHub
//
//  Created by nikita on 16.09.2025.
//

import SwiftUI
import Combine

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var viewState: SearchViewState = .empty
    @Published var showFilters: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSearchSubscription()
    }
    
    func performSearch(query: String) async {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            viewState = .empty
            return
        }

        viewState = .loading

        do {
            let events = try await DataManager.shared.searchEvents(query: query)
            if events.isEmpty {
                viewState = .empty
            } else {
                viewState = .loaded(events)
            }
        } catch {
            viewState = .error(error.localizedDescription)
        }
    }
    
    func clearSearch() {
        searchText = ""
        viewState = .empty
    }
    
    func applyFilters() {
        Task {
            await performSearch(query: searchText)
        }
    }
}

private extension SearchViewModel {
    func setupSearchSubscription() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                Task {
                    await self?.performSearch(query: searchText)
                }
            }
            .store(in: &cancellables)
    }
}
