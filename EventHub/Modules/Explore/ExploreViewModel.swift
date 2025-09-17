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
    @Published var selectedLocation: String = "msk" // Добавим переменную для локации
    
    private let dataManager = DataManager.shared
    
    func loadInitialData() async {
        state = .loading
        
        do {
            // Загружаем категории
            categories = try await dataManager.getCategories()
            
            // Создаем модели категорий с цветами и иконками
            categoryModels = categories.map { CategoryModel(category: $0) }
            
            // Загружаем события без фильтрации
            upcommingEvents = try await dataManager.getUpcamingEvents()
            nearbyEvents = try await dataManager.getNearByEvents(location: selectedLocation)
            
            state = .loaded(upcommingEvents)
            
        } catch {
            state = .error(error)
            print("Error loading data: \(error)")
        }
    }
    
    func loadEventsWithSelectedCategories() async {
        state = .loading
        
        do {
            let categoryNames: [String]
            
            if selectedCategoryIds.isEmpty {
                // Если нет выбранных категорий, загружаем все события
                upcommingEvents = try await dataManager.getUpcamingEvents()
                nearbyEvents = try await dataManager.getNearByEvents(location: selectedLocation)
            } else {
                // Фильтруем по выбранным категориям
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
    
    // Функция для поиска событий
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
    
    // Функция для обновления локации
    func updateLocation(_ location: String) async {
        selectedLocation = location
        await loadEventsWithSelectedCategories()
    }
    
    // Функция для сброса фильтров
    func clearFilters() {
        selectedCategoryIds.removeAll()
        searchQuery = ""
    }
    
    // Функция для проверки, активны ли какие-либо фильтры
    var hasActiveFilters: Bool {
        !selectedCategoryIds.isEmpty || !searchQuery.isEmpty
    }
    
    // MARK: - Getter Methods
    
    func getCategoryViewModel() -> [CategoryModel] {
        return categoryModels
    }
    
    func getUpcommingViewModel() -> [Event] {
        return Array(upcommingEvents.prefix(6)) // Показываем первые 6 событий
    }
    
    func getNearbyViewModel() -> [Event] {
        return Array(nearbyEvents.prefix(6)) // Показываем первые 6 событий
    }
    
    func getAllUpcomingEvents() -> [Event] {
        return upcommingEvents
    }
    
    func getAllNearbyEvents() -> [Event] {
        return nearbyEvents
    }
    
    // Проверяем, есть ли еще события для показа
    func hasMoreUpcomingEvents() -> Bool {
        upcommingEvents.count > 6
    }
    
    func hasMoreNearbyEvents() -> Bool {
        nearbyEvents.count > 6
    }
    
    // Получаем выбранные категории для отображения
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

// Состояния загрузки
enum ViewState<T> {
    case idle
    case loading
    case loaded(T)
    case error(Error)
}

// Расширение для удобного отображения ошибок
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
