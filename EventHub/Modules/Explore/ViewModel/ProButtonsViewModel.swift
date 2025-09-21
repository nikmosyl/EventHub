import Foundation

@MainActor
final class ProButtonsViewModel: ObservableObject {
    
    @Published var todayEvents = [Event]()
    @Published var filmsEvents = [Event]()
    @Published var listsEvents = [Event]()
    @Published var isLoading = false
    @Published var error: Error?
    
    private let dataManager = DataManager.shared
    
    //MARK: - Получение фильмов по slug "films"
    func fetchFilmsEvents() async throws -> [Event] {
        // Используем категорию "films" для фильтрации
        return try await dataManager.getUpcamingEvents(categories: ["films"])
    }
    
    //MARK: - Фильтр для определенного дня
    func filterTodayEvents(from events: [Event]) -> [Event] {
        let calendar = Calendar.current
        let today = Date()
        
        return events.filter { event in
            guard let eventDate = event.dates?.first,
                  let startTimestamp = eventDate.start else {
                return false
            }
            
            let eventStartDate = Date(timeIntervalSince1970: TimeInterval(startTimestamp))
            return calendar.isDate(eventStartDate, inSameDayAs: today)
        }
    }
    
    // Получение списков (подборок)
    func fetchLists() async throws -> [ListItem] {
        return try await dataManager.fetchLists()
    }
    
    // Загрузка фильмов
    func loadFilms() async {
        isLoading = true
        error = nil
        
        do {
            filmsEvents = try await fetchFilmsEvents()
        } catch {
            self.error = error
            print("Error loading films: \(error)")
        }
        
        isLoading = false
    }
}
