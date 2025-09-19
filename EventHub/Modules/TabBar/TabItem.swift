//
//  TabItem.swift
//  EventHub
//
//  Created by nikita on 09.09.2025.
//

import SwiftUI

enum TabItem: CaseIterable {
    case explore
    case events
    case bookmark
    case map
    case profile
    
    var icon: String {
        return switch self {
        case .explore: "Explore"
        case .events: "Events"
        case .bookmark: "bookmark"
        case .map: "Map"
        case .profile: "Profile"
        }
    }
    
    //    @ViewBuilder
    //    var view: some View {
    //        switch self {
    //        case .explore:
    //            ExploreView()
    //        case .events:
    //            EventsView()
    //        case .bookmark:
    //            FavoritesView()
    //        case .map:
    //            TestView()
    //        case .profile:
    //            ProfileView()
    //        }
    //    }
}

// MARK: - Примеры экранов
struct ExploreView: View {
    var body: some View {
        ZStack {
            Color
                .red
                .ignoresSafeArea()
            Text("ExploreView")
        }
    }
}

struct EventsView: View {
    var body: some View {
        ZStack {
            Color
                .green
                .ignoresSafeArea()
            Text("EventsView")
        }
    }
}

struct MapView: View {
    var body: some View {
        ZStack {
            Color
                .cyan
                .ignoresSafeArea()
            Text("MapView")
        }
    }
}


//MARK: пример использования DataManager
struct TestView: View {
    @StateObject private var viewModel = TestViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.events, id: \.id) { event in
                    EventCellView(event: event)
                }
            }
        }
        .navigationTitle("TEST")
    }
}

@MainActor
final class TestViewModel: ObservableObject {
    @Published var events: [Event] = []
    
    init() {
        loadEvents()
    }
    
    func loadEvents() {
        Task {
            do {
                let ids = DataManager.shared.getFavoritesIds()
                let events = try await DataManager.shared.getUpcamingEvents()
                self.events = events
            } catch {
                print("ProfileViewModel Ошибка при загрузке событий, ошибка: \(error)")
                if let netError = error as? NetworkError {
                    switch netError {
                    case .invalidResponse:
                        print("⚠️ Некорректный ответ сервера")
                    case .badStatus(let code):
                        print("⚠️ Сервер вернул статус: \(code)")
                    case .decoding(let decodeError):
                        print("⚠️ Ошибка декодирования:", decodeError)
                    case .invalidURL:
                        print("⚠️ Ошибка url:")
                    }
                }
                self.events = []
            }
        }
    }
}

#Preview {
    TabBarView()
}
