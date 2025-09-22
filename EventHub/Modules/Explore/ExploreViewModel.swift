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
    @Published var selectedCategoryIds: Set<Int> = [] {
        didSet {
            updateCachedSelectedCategorySlugs()
            if isInitialLoadComplete {
                Task {
                    await reloadEventsWithSelectedCategories()
                }
            }
        }
    }
    @Published var favoriteEventIds: Set<Int> = []
    @Published var searchQuery: String = ""
    @Published var availableLocations: [Location] = []
    @Published var selectedLocation: String = "msk"
    @Published var isLoadingLocations: Bool = false
    @Published var isLoadingEvents: Bool = false
    
    //MARK: - Private Properties
    private var isInitialLoadComplete: Bool = false
    private let dataManager = DataManager.shared
    private var cachedSelectedCategorySlugs: [String] = []
    private var allUpcommingEvents: [Event] = []
    private var currentTask: Task<Void, Never>?
    
    //MARK: - Public Methods
    
    func loadInitialData() async {
        guard !isInitialLoadComplete else { return }
        
        currentTask?.cancel()
        
        currentTask = Task {
            state = .loading
            
            do {
                async let categoriesTask = dataManager.getCategories()
                await loadLocations()
                
                categories = try await categoriesTask
                categoryModels = categories.map { CategoryModel(category: $0) }

                allUpcommingEvents = try await dataManager.getUpcamingEvents(location: selectedLocation)
                nearbyEvents = try await dataManager.getNearByEvents(location: selectedLocation)
                
                upcommingEvents = allUpcommingEvents
                state = .loaded(upcommingEvents)
                isInitialLoadComplete = true
                
            } catch {
                if !Task.isCancelled {
                    state = .error(error)
                    print("Error loading data: \(error)")
                }
            }
        }
        
        await currentTask?.value
    }
    
    func refreshData() async {
        currentTask?.cancel()
        
        currentTask = Task {
            selectedCategoryIds = []

            await reloadEventsWithoutFilters()
        }
        
        await currentTask?.value
    }
    
    private func reloadEventsWithoutFilters() async {
        guard !Task.isCancelled else { return }
        
        isLoadingEvents = true
        state = .loading
        
        do {
            allUpcommingEvents = try await dataManager.getUpcamingEvents(location: selectedLocation)
            nearbyEvents = try await dataManager.getNearByEvents(location: selectedLocation)
            
            guard !Task.isCancelled else { return }
            
            upcommingEvents = allUpcommingEvents
            state = .loaded(upcommingEvents)
            
        } catch {
            if !Task.isCancelled {
                state = .error(error)
                print("Error loading events without filters: \(error)")
            }
        }
        
        isLoadingEvents = false
    }
    
    private func reloadEventsWithSelectedCategories() async {
        guard !Task.isCancelled else { return }
        
        isLoadingEvents = true
        
        do {
            let categorySlugs = cachedSelectedCategorySlugs.isEmpty ? nil : cachedSelectedCategorySlugs
            
            allUpcommingEvents = try await dataManager.getUpcamingEvents(location: selectedLocation, categories: categorySlugs)
            nearbyEvents = try await dataManager.getNearByEvents(
                location: selectedLocation,
                categories: categorySlugs
            )
            
            guard !Task.isCancelled else { return }
            
            upcommingEvents = allUpcommingEvents
            state = .loaded(upcommingEvents)
            
        } catch {
            if !Task.isCancelled {
                state = .error(error)
                print("Error loading events with categories: \(error)")
            }
        }
        
        isLoadingEvents = false
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
    
    var hasMoreUpcomingEvents: Bool {
        upcommingEvents.count > 6
    }
    
    var hasMoreNearbyEvents: Bool {
        nearbyEvents.count > 6
    }
    
    func updateLocation(_ location: String) async {
        selectedLocation = location
        await reloadEventsWithSelectedCategories()
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
    
    private func updateCachedSelectedCategorySlugs() {
        cachedSelectedCategorySlugs = categories
            .filter { category in
                guard let categoryId = category.id else { return false }
                return selectedCategoryIds.contains(categoryId)
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
