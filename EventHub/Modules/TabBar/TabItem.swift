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
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .explore:
            ExploreView()
        case .events:
            EventsView()
        case .bookmark:
            BookmarkView()
        case .map:
            TestView()
        case .profile:
            ProfileView(profile: .example)
        }
    }
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

struct BookmarkView: View {
    var body: some View {
        ZStack {
            Color
                .blue
                .ignoresSafeArea()
            Text("BookmarkView")
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
                    EventRow(event: event, viewModel: viewModel)
                }
            }
        }
    }
}

struct EventRow: View {
    let event: Event
    @ObservedObject var viewModel: TestViewModel
    
    var body: some View {
        VStack() {
            Text(event.title)
            
            if let imageUrl = event.images?.first?.image {
                HStack {
                    NetworkImage(imageUrl: imageUrl)
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Text(event.shortTitle ?? "Пустой title")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            else {
                Text("Не удалось загрузить детали")
                    .foregroundColor(.red)
                    .font(.footnote)
            }
            
            if let next = event.nextDate, let start = next.start{
                Text("next: \(next.formatter(date: start, format: "EEE, MMM d • h:mm a"))")
            }
            
            if let prev = event.previousDate, let start = prev.start {
                Text("prev: \(prev.formatter(date: start, format: "EEE, MMM d • h:mm a"))")
            }
        }
        .background(Color.gray)
        .padding()
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
