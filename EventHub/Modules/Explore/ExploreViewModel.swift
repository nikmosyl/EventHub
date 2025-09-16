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
    @Published var upcommingEvents: [Event] = []
    @Published var nearbyEvents: [Event] = []
    
    private let categoryiesType: CategoryTypes = .art
    
    private let dataManager = DataManager.shared
    
    func loadInitialData() async {
        state = .loading
        
        do {
            categories = try await dataManager.getCategories()
            
            upcommingEvents = try await dataManager.getUpcamingEvents()
            
            nearbyEvents = try await dataManager.getNearByEvents(location: "msk")
            
            state = .loaded(upcommingEvents)
            
        } catch {
            state = .error(error)
            print("Error loading data: \(error)")
        }
    }
    
    func getCategoryViewModel() -> [CategoryModel] {
        return categories.map { category in
            let categores = CategoryTypes.from(name: category.name)
            return CategoryModel(id: category.id,
                                 name: category.name,
                                 icon: categores.systemIcon,
                                 color: categores.color)
        }
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
