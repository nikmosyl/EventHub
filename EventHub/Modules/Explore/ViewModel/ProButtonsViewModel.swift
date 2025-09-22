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
}
