//
//  ExploreViewModel.swift
//  EventHub
//
//  Created by Drolllted on 09.09.2025.
//

import Foundation

@MainActor
final class ExploreViewModel: ObservableObject {
    
    //MARK: - Published Properties
    @Published var state: ViewState<[Event]> = .idle
    @Published var categories: [EventCategory] = []
    @Published var categoryModels: [CategoryModel] = []
    @Published var upcommingEvents: [Event] = []
    @Published var nearbyEvents: [Event] = []
    @Published var excludedCategoryIds: Set<Int> = [] {
        didSet {
            if isInitialLoadComplete {
                Task {
                    await loadEventsWithExcludedCategories()
                }
            }
        }
    }
    @Published var favoriteEventIds: Set<Int> = []
    @Published var searchQuery: String = ""
    @Published var availableLocations: [Location] = []
    @Published var selectedLocation: String = "msk"
    @Published var isLoadingLocations: Bool = false
    
    //MARK: - Private Properties
    private var isInitialLoadComplete: Bool = false
    private let dataManager = DataManager.shared
    
    //MARK: - Public Methods
    
    func loadInitialData() async {
        state = .loading
        
        do {
            async let categoriesTask = dataManager.getCategories()
            await loadLocations()
            
            categories = try await categoriesTask
            categoryModels = categories.map { CategoryModel(category: $0) }

            excludedCategoryIds = []
            
            upcommingEvents = try await dataManager.getUpcamingEvents()
            nearbyEvents = try await dataManager.getNearByEvents(location: selectedLocation)
            
            state = .loaded(upcommingEvents)
            isInitialLoadComplete = true
            
        } catch {
            state = .error(error)
            print("Error loading data: \(error)")
        }
    }
    
    // MARK: - Getter Methods for Views
    
    func getCurrentLocationName() -> String {
        availableLocations.first { $0.slug == selectedLocation }?.name ?? selectedLocation
    }
    
    func getCategoryForExploreView() -> [CategoryModel] {
        categoryModels
    }
    
    func getUpcommingForExploreView() -> [Event] {
        Array(upcommingEvents.prefix(6))
    }
    
    func getNearbyEventsForExploreView() -> [Event] {
        Array(nearbyEvents.prefix(6))
    }
    
    func getAllUpcomingEvents() -> [Event] {
        upcommingEvents
    }
    
    func getAllNearbyEvents() -> [Event] {
        nearbyEvents
    }
    
    var hasActiveFilters: Bool {
        !excludedCategoryIds.isEmpty || !searchQuery.isEmpty
    }
    
    var hasMoreUpcomingEvents: Bool {
        upcommingEvents.count > 6
    }
    
    var hasMoreNearbyEvents: Bool {
        nearbyEvents.count > 6
    }
    
    func updateLocation(_ location: String) async {
           selectedLocation = location
           await loadEventsWithExcludedCategories()
    }
    
    //MARK: - Private Methods
    
    private func loadLocations() async {
        isLoadingLocations = true
        
        do {
            availableLocations = try await dataManager.getLocations()
            print("Успешно загружено локаций: \(availableLocations.count)")
            
        } catch {
            print("Ошибка загрузки локаций: \(error)")
        }
        
        isLoadingLocations = false
    }
    
    private func loadEventsWithExcludedCategories() async {
        state = .loading
        
        do {
            let excludedCategorySlugs: [String]
            
            if excludedCategoryIds.isEmpty {
                upcommingEvents = try await dataManager.getUpcamingEvents()
                nearbyEvents = try await dataManager.getNearByEvents(location: selectedLocation)
            } else {
                excludedCategorySlugs = getExcludedCategorySlugs()
                
                let allCategories = categories.compactMap { $0.slug }
                let includedCategories = allCategories.filter { !excludedCategorySlugs.contains($0) }
                
                upcommingEvents = try await dataManager.getUpcamingEvents(categories: includedCategories)
                nearbyEvents = try await dataManager.getNearByEvents(
                    location: selectedLocation,
                    categories: includedCategories
                )
            }
            
            state = .loaded(upcommingEvents)
            
        } catch {
            let formattedError = formatError(error)
            state = .error(formattedError)
            print("Error loading filtered events: \(formattedError)")
        }
    }
    
    private func getExcludedCategorySlugs() -> [String] {
        categories
            .filter { category in
                guard let categoryId = category.id else { return false }
                return excludedCategoryIds.contains(categoryId)
            }
            .compactMap { $0.slug }
    }
    
    private func formatError(_ error: Error) -> Error {
        if let networkError = error as? NetworkError {
            return networkError
        } else if let _ = error as? DecodingError {
            return NetworkError.invalidURL
        } else {
            return NetworkError.invalidResponse
        }
    }
}

enum ViewState<T> {
    case idle
    case loading
    case loaded(T)
    case error(Error)
}
