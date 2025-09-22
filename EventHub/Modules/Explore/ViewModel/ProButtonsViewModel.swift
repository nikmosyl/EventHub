import Foundation

@MainActor
final class ProButtonsViewModel: ObservableObject {
    @Published var filmsEvents = [Event]()
    @Published var listsEvents = [Event]()
    @Published var isLoading = false
    @Published var error: Error?
    @Published var todayEvents: [Event] = []
    
    init(location: String) {
        Task {
            await loadTodays(location: location)
            await loadFilms(location: location)
        }
    }
    
    func loadTodays(location: String) async {
        print("запрос сегодняшних")
        do {
            todayEvents = try await DataManager.shared.getTodayEvents(location: location)
            print("сегодня будет \(todayEvents.count) events")
        } catch {
            print("не удалось загрузить сегодняшние события")
        }
    }
    
    func loadFilms(location: String) async {
        do {
            filmsEvents = try await DataManager.shared.getUpcamingEvents(location: location, categories: ["cinema"])
            print("Количество пришедших данных: \(filmsEvents)")
        } catch {
            print("Не удалось получить фильмы")
            print(error.localizedDescription)
        }
    }
}
