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
    @Published var selectedCategoryIds: Set<Int> = [] {
        didSet {
            if isInitialLoadComplete {
                Task{
                    await loadEventsWithSelectedCategories()
                }
            }
        }
    }
    @Published var searchQuery: String = ""
    @Published var availableLocations: [Location] = []
    @Published var selectedLocation: String = "msk"
    @Published var isLoadingLocations: Bool = false
    private var isInitialLoadComplete: Bool = false
    private let dataManager = DataManager.shared
    
    func loadInitialData() async {
        state = .loading
        
        do {
            async let categoriesTask = dataManager.getCategories()
            await loadLocations()
            
            categories = try await categoriesTask
            categoryModels = categories.map { CategoryModel(category: $0) }
            
            upcommingEvents = try await dataManager.getUpcamingEvents()
            nearbyEvents = try await dataManager.getNearByEvents(location: selectedLocation)
            
            state = .loaded(upcommingEvents)
            isInitialLoadComplete = true
        } catch {
            state = .error(error)
            print("Error loading data: \(error)")
        }
    }
    
    func loadLocations() async {
        isLoadingLocations = true
        print("Начинаем загрузку локаций...")
        
        do {
            availableLocations = try await dataManager.getLocations()
            print("Успешно загружено локаций: \(availableLocations.count)")
            
            for (index, location) in availableLocations.enumerated() {
                print("Локация \(index): \(location.name ?? "No name"), slug: \(location.slug ?? "No slug")")
            }
            
        } catch {
            print("Ошибка загрузки локаций: \(error)")
            print("Используем fallback локации: \(availableLocations.map { $0.name ?? "" })")
        }
        
        isLoadingLocations = false
    }
    
    func loadEventsWithSelectedCategories() async {
        state = .loading
        print("Входим в do")
        do {
            print("Зашли в do")
            let categorySlugs: [String]
            print("Обработали categoryNames")
            if selectedCategoryIds.isEmpty {
                upcommingEvents = try await dataManager.getUpcamingEvents()
                nearbyEvents = try await dataManager.getNearByEvents(location: selectedLocation)
                print("Проверили если пустота")
            } else {
                categorySlugs = getSelectedCategorySlug()
                
                upcommingEvents = try await dataManager.getUpcamingEvents(categories: categorySlugs)
                nearbyEvents = try await dataManager.getNearByEvents(
                    location: selectedLocation,
                    categories: categorySlugs
                )
                print("Если не пустота")
            }
            
            state = .loaded(upcommingEvents)
            
        } catch {
            let formattedError = formatError(error)
            state = .error(formattedError)
            print("Error loading filtered events: \(formattedError)")
        }
    }
    
    private func formatError(_ error: Error) -> Error {
        if let networkError = error as? NetworkError {
            return networkError
        } else if let decodingError = error as? DecodingError {
            return NetworkError.invalidURL
        } else {
            return NetworkError.invalidResponse
        }
    }
    
    private func getSelectedCategorySlug() -> [String] {
        categories
            .filter { category in
                if let categoryId = category.id {
                    return selectedCategoryIds.contains(categoryId)
                }
                return false
            }
            .compactMap { $0.slug }
    }
    
    func searchEvents() async {
        state = .loading
        
        do {
            let events = try await dataManager.searchEvents(
                query: searchQuery,
                location: selectedLocation
            )
            
            upcommingEvents = events
            state = .loaded(events)
            
        } catch {
            state = .error(error)
            print("Error searching events: \(error)")
        }
    }
    
    func updateLocation(_ location: String) async {
        selectedLocation = location
        await loadEventsWithSelectedCategories()
    }
    
    func getCurrentLocationName() -> String {
        if let currentLocation = availableLocations.first(where: {$0.slug == selectedLocation}) {
            return currentLocation.name ?? selectedLocation
        }
        return selectedLocation
    }
    
    func clearFilters() {
        selectedCategoryIds.removeAll()
        searchQuery = ""
    }
    
    var hasActiveFilters: Bool {
        !selectedCategoryIds.isEmpty || !searchQuery.isEmpty
    }
    
    // MARK: - Getter Methods
    
    func getCategoryForExploreView() -> [CategoryModel] {
        return categoryModels
    }
    
    func getUpcommingForExploreView() -> [Event] {
        return Array(upcommingEvents.prefix(6))
    }
    
    func getNearbyEventsForExploreView() -> [Event] {
        return Array(nearbyEvents.prefix(6))
    }
    
    func getAllUpcomingEvents() -> [Event] {
        return upcommingEvents
    }
    
    func getAllNearbyEvents() -> [Event] {
        return nearbyEvents
    }
    
    func hasMoreUpcomingEvents() -> Bool {
        upcommingEvents.count > 6
    }
    
    func hasMoreNearbyEvents() -> Bool {
        nearbyEvents.count > 6
    }
}
enum ViewState<T> {
    case idle
    case loading
    case loaded(T)
    case error(Error)
}
