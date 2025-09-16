//
//  ExploreViewModel.swift
//  EventHub
//
//  Created by Drolllted on 09.09.2025.
//

import Foundation

@MainActor
final class ExploreViewModel: ObservableObject {
    @Published var state: ViewState<[Event]> = .idle
    @Published var categories: [EventCategory] = []
    @Published var categoryModels: [CategoryModel] = []
    @Published var upcommingEvents: [Event] = []
    @Published var nearbyEvents: [Event] = []
    @Published var selectedCategoryIds: Set<Int> = []
    
    private let dataManager = DataManager.shared
    
    func loadInitialData() async {
        state = .loading
        
        do {
            categories = try await dataManager.getCategories()
            
            categoryModels = categories.map {CategoryModel(category: $0)}
            
            upcommingEvents = try await dataManager.getUpcamingEvents()
            
            nearbyEvents = try await dataManager.getNearByEvents(location: "msk")
            
            state = .loaded(upcommingEvents)
            
        } catch {
            state = .error(error)
            print("Error loading data: \(error)")
        }
    }
    
    func loadEventsWithSelectedCategories() async {
        guard !selectedCategoryIds.isEmpty else {
            await loadInitialData()
            return
        }
        
        state = .loading
        
        do {
            let categoryNames = categories
                .filter { selectedCategoryIds.contains($0.id) }
                .map { $0.name }
            
            upcommingEvents = try await dataManager.getUpcamingEvents(categories: categoryNames)
            nearbyEvents = try await dataManager.getNearByEvents(
                location: "msk",
                categories: categoryNames
            )
            
            state = .loaded(upcommingEvents)
            
        } catch {
            state = .error(error)
            print("Error loading filtered events: \(error)")
        }
    }
    
    func getCategoryViewModel() -> [CategoryModel] {
        return categoryModels
    }
    
    func getUpcommnigViewModel() -> [Event] {
        return upcommingEvents
    }
    
    func getNearbyViewModel() -> [Event] {
        return nearbyEvents
    }
    
    
}

// Состояния загрузки
enum ViewState<T> {
    case idle
    case loading
    case loaded(T)
    case error(Error)
}
