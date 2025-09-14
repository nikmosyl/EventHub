//
//  ExploreViewModel.swift
//  EventHub
//
//  Created by Drolllted on 09.09.2025.
//

import Foundation

final class ExploreViewModel: ObservableObject{
    //MARK: - Variables
    
    @Published var state: State = .idle
    @Published var selectedCategory: String?
    @Published var searchText = ""
    
    //MARK: - Methods API
    
    @MainActor
    func loadInitialData() async {
        state = .loading
        
        do {
            async let categoriesTask = DataManager.shared.getCategories()
            async let upcommingEventsTask = DataManager.shared.getUpcamingEvents()
            async let nearbyEventsTask = DataManager.shared.getNearByEvents(location: "msk") // Это надо будет исправить(выбор города)
            
            let (categories, upcommingEvents, nearbyEvents) = try await (categoriesTask, upcommingEventsTask, nearbyEventsTask)
            let content = ExplorerContent(
                categories: categories,
                upCommingEvents: upcommingEvents,
                nearbyEvents: nearbyEvents
            )
            
            state = .loaded(content)
            
        } catch {
            state = .error(error)
            print("Проблема в loadInitialData!!! : \(error.localizedDescription)")
        }
    }
    
    
    
    //MARK: - Methods for UI
    
    //For VariableSectionView
    
    func getCategoryViewModel() -> [CategoryCellViewModel] {
        guard case .loaded(let content) = state else {return []}
        return content.categories.map {CategoryCellViewModel(category: $0)}
    }
    
    func getUpcommnigViewModel() -> [EventCardViewModel] {
        guard case .loaded(let content) = state else {return []}
        return content.upCommingEvents.prefix(5).map {EventCardViewModel(event: $0)}
    }
    
    func getNearbyViewModel() -> [EventCardViewModel] {
        guard case .loaded(let content) = state else {return []}
        return content.nearbyEvents.prefix(5).map {EventCardViewModel(event: $0)}
    }
    
}

extension ExploreViewModel {
    enum State {
        case idle
        case loading
        case loaded(ExplorerContent)
        case error(Error)
        
    }
    
    struct ExplorerContent{
        var categories: [EventCategory] = []
        var upCommingEvents: [Event] = []
        var nearbyEvents: [Event] = []
        var featuresEvents: [Event] = []
    }
}
