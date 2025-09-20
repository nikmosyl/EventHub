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
            updateCachedExcludedCategorySlugs()
            if isInitialLoadComplete {
                filterEventsByExcludedCategories()
            }
        }
    }
    @Published var filteredUpcommingEvents: [Event] = []
    @Published var filteredNearbyEvents: [Event] = []
    @Published var favoriteEventIds: Set<Int> = []
    @Published var searchQuery: String = ""
    @Published var availableLocations: [Location] = []
    @Published var selectedLocation: String = "msk"
    @Published var isLoadingLocations: Bool = false
    
    //MARK: - Private Properties
    private var isInitialLoadComplete: Bool = false
    private let dataManager = DataManager.shared
    private var cachedExcludedCategorySlugs: Set<String> = []
    
    //MARK: - Public Methods
    
    func loadInitialData() async {
        guard !isInitialLoadComplete else {return}
        state = .loading
        
        do {
            async let categoriesTask = dataManager.getCategories()
            await loadLocations()
            
            categories = try await categoriesTask
            categoryModels = categories.map { CategoryModel(category: $0) }

            upcommingEvents = try await dataManager.getUpcamingEvents()
            nearbyEvents = try await dataManager.getNearByEvents(location: selectedLocation)
            
            filterEventsByExcludedCategories()
            
            state = .loaded(filteredUpcommingEvents)
            isInitialLoadComplete = true
            
        } catch {
            state = .error(error)
            print("Error loading data: \(error)")
        }
    }
    
    func refreshData() async {
        state = .loading
        do {
            async let categoriesTask = dataManager.getCategories()
            await loadLocations()
            
            categories = try await categoriesTask
            categoryModels = categories.map { CategoryModel(category: $0) }

            upcommingEvents = try await dataManager.getUpcamingEvents()
            nearbyEvents = try await dataManager.getNearByEvents(location: selectedLocation)
            
            filterEventsByExcludedCategories()
            
            state = .loaded(filteredUpcommingEvents)
        } catch {
            state = .error(error)
            print("Error Refresh Data: \(error)")
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
        Array(filteredUpcommingEvents.prefix(6))
    }
    
    func getNearbyEventsForExploreView() -> [Event] {
        Array(filteredNearbyEvents.prefix(6))
    }
    
    func getAllUpcomingEvents() -> [Event] {
        filteredUpcommingEvents
    }
    
    func getAllNearbyEvents() -> [Event] {
        filteredNearbyEvents
    }
    
    var hasActiveFilters: Bool {
        !excludedCategoryIds.isEmpty || !searchQuery.isEmpty
    }
    
    var hasMoreUpcomingEvents: Bool {
        filteredUpcommingEvents.count > 6
    }
    
    var hasMoreNearbyEvents: Bool {
        filteredNearbyEvents.count > 6
    }
    
    func updateLocation(_ location: String) async {
        selectedLocation = location
        await reloadEventsForCurrentLocation()
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
    
    private func reloadEventsForCurrentLocation() async {
        state = .loading
        
        do {
            upcommingEvents = try await dataManager.getUpcamingEvents()
            nearbyEvents = try await dataManager.getNearByEvents(location: selectedLocation)
            
            filterEventsByExcludedCategories()
            state = .loaded(filteredUpcommingEvents)
            
        } catch {
            let formattedError = formatError(error)
            state = .error(formattedError)
            print("Error loading events for location: \(formattedError)")
        }
    }
    
    private func filterEventsByExcludedCategories() {
        if cachedExcludedCategorySlugs.isEmpty {
            filteredUpcommingEvents = upcommingEvents
            filteredNearbyEvents = nearbyEvents
        } else {
            filteredUpcommingEvents = upcommingEvents.filter { event in
                !eventContainsExcludedCategories(event)
            }
            
            filteredNearbyEvents = nearbyEvents.filter { event in
                !eventContainsExcludedCategories(event)
            }
        }
    }
    
    private func eventContainsExcludedCategories(_ event: Event) -> Bool {
        guard let eventCategorySlugs = event.categories, !eventCategorySlugs.isEmpty else { return false }

        return eventCategorySlugs.contains { cachedExcludedCategorySlugs.contains($0) }
    }
    
    private func updateCachedExcludedCategorySlugs() {
        cachedExcludedCategorySlugs = Set(
            categories
                .filter { category in
                    guard let categoryId = category.id else { return false }
                    return excludedCategoryIds.contains(categoryId)
                }
                .compactMap { $0.slug }
        )
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
