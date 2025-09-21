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
    @Published var showOnlyTodayEvents: Bool = false
    @Published var showOnlyFilms: Bool = false
    
    //MARK: - Private Properties
    private var isInitialLoadComplete: Bool = false
    private let dataManager = DataManager.shared
    private var cachedSelectedCategorySlugs: [String] = []
    private var allUpcommingEvents: [Event] = [] // Храним все события для фильтрации
    
    //MARK: - Public Methods
    
    func loadInitialData() async {
        guard !isInitialLoadComplete else { return }
        state = .loading
        
        do {
            async let categoriesTask = dataManager.getCategories()
            await loadLocations()
            
            categories = try await categoriesTask
            categoryModels = categories.map { CategoryModel(category: $0) }

            // Загружаем события без фильтров (все категории)
            allUpcommingEvents = try await dataManager.getUpcamingEvents()
            nearbyEvents = try await dataManager.getNearByEvents(location: selectedLocation)
            
            upcommingEvents = allUpcommingEvents
            state = .loaded(upcommingEvents)
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

            // Перезагружаем события с текущими выбранными категориями
            await reloadEventsWithSelectedCategories()
            
        } catch {
            state = .error(error)
            print("Error Refresh Data: \(error)")
        }
    }
    
    // Загрузка событий с выбранными категориями
    private func reloadEventsWithSelectedCategories() async {
        isLoadingEvents = true
        state = .loading
        
        do {
            // Если нет выбранных категорий - загружаем все события
            let categorySlugs = cachedSelectedCategorySlugs.isEmpty ? nil : cachedSelectedCategorySlugs
            
            allUpcommingEvents = try await dataManager.getUpcamingEvents(categories: categorySlugs)
            nearbyEvents = try await dataManager.getNearByEvents(
                location: selectedLocation,
                categories: categorySlugs
            )
            
            // Применяем текущие фильтры (сегодня/фильмы)
            applyCurrentFilters()
            
        } catch {
            state = .error(error)
            print("Error loading events with categories: \(error)")
        }
        
        isLoadingEvents = false
    }
    
    // MARK: - Обработчики кнопок
    
    func showTodayEvents() {
        showOnlyTodayEvents = true
        showOnlyFilms = false
        applyCurrentFilters()
    }
    
    func showFilms() {
        showOnlyFilms = true
        showOnlyTodayEvents = false
        applyCurrentFilters()
    }
    
    func showAllEvents() {
        showOnlyTodayEvents = false
        showOnlyFilms = false
        applyCurrentFilters()
    }
    
    // Применение текущих фильтров
    private func applyCurrentFilters() {
        if showOnlyTodayEvents {
            filterTodayEvents()
        } else if showOnlyFilms {
            filterFilms()
        } else {
            upcommingEvents = allUpcommingEvents
        }
        state = .loaded(upcommingEvents)
    }
    
    // Фильтрация событий на сегодня
    private func filterTodayEvents() {
        let calendar = Calendar.current
        let today = Date()
        
        upcommingEvents = allUpcommingEvents.filter { event in
            guard let eventDate = event.dates?.first,
                  let startTimestamp = eventDate.start else {
                return false
            }
            
            let eventStartDate = Date(timeIntervalSince1970: TimeInterval(startTimestamp))
            
            return calendar.isDate(eventStartDate, inSameDayAs: today)
        }
    }
    
    // Фильтрация фильмов
    private func filterFilms() {

        upcommingEvents = allUpcommingEvents.filter { event in
            event.categories?.contains("films") == true ||
            event.categories?.contains("cinema") == true ||
            event.title?.lowercased().contains("film") == true ||
            event.title?.lowercased().contains("movie") == true
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
        !selectedCategoryIds.isEmpty || !searchQuery.isEmpty || showOnlyTodayEvents || showOnlyFilms
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
