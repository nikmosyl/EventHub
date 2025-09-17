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
    @Published var searchQuery: String = ""
    @Published var availableLocations: [Location] = []
    @Published var selectedLocation: String = "msk"
    @Published var isLoadingLocations: Bool = false
    
    private let dataManager = DataManager.shared
    
    func loadInitialData() async {
        state = .loading
        
        do {
            async let categoriesTask = dataManager.getCategories()
            async let locationsTask: () = loadLocations()
            
            categories = try await categoriesTask
            categoryModels = categories.map { CategoryModel(category: $0) }

            upcommingEvents = try await dataManager.getUpcamingEvents()
            nearbyEvents = try await dataManager.getNearByEvents(location: selectedLocation)
            
            state = .loaded(upcommingEvents)
            
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
            availableLocations = [
                Location(slug: "msk", name: "Москва", coords: nil),
                Location(slug: "spb", name: "Санкт-Петербург", coords: nil),
                Location(slug: "nsk", name: "Новосибирск", coords: nil)
            ]
            print("Используем fallback локации: \(availableLocations.map { $0.name ?? "" })")
        }
        
        isLoadingLocations = false
    }
    
    func loadEventsWithSelectedCategories() async {
        state = .loading
        
        do {
            let categoryNames: [String]
            
            if selectedCategoryIds.isEmpty {
                upcommingEvents = try await dataManager.getUpcamingEvents()
                nearbyEvents = try await dataManager.getNearByEvents(location: selectedLocation)
            } else {
                categoryNames = categories
                    .filter { category in
                        if let categoryId = category.id {
                            return selectedCategoryIds.contains(categoryId)
                        }
                        return false
                    }
                    .map { $0.name ?? "Unknown" }
                
                upcommingEvents = try await dataManager.getUpcamingEvents(categories: categoryNames)
                nearbyEvents = try await dataManager.getNearByEvents(
                    location: selectedLocation,
                    categories: categoryNames
                )
            }
            
            state = .loaded(upcommingEvents)
            
        } catch {
            state = .error(error)
            print("Error loading filtered events: \(error)")
        }
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
    
    func getCategoryViewModel() -> [CategoryModel] {
        return categoryModels
    }
    
    func getUpcommingViewModel() -> [Event] {
        return Array(upcommingEvents.prefix(6))
    }
    
    func getNearbyViewModel() -> [Event] {
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
    
    func getSelectedCategoryNames() -> [String] {
        categories
            .filter { category in
                if let categoryId = category.id {
                    return selectedCategoryIds.contains(categoryId)
                }
                return false
            }
            .map { $0.name ?? "Unknown" }
    }
}

enum ViewState<T> {
    case idle
    case loading
    case loaded(T)
    case error(Error)
}

extension ViewState: Equatable where T: Equatable {
    static func == (lhs: ViewState<T>, rhs: ViewState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.loaded(let lhsValue), .loaded(let rhsValue)):
            return lhsValue == rhsValue
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
