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
            MapView()
        case .profile:
            ProfileView()
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
struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
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
    let event: EventItem
    @ObservedObject var viewModel: ProfileViewModel
    @State private var details: EventDetails?
    @State private var isLoading = true
    
    var body: some View {
        VStack() {
            Text(event.title)
            
            if isLoading {
                ProgressView()
            } else if let imageUrl = details?.images?.first?.image {
                
                HStack {
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipped()
                    } placeholder: {
                        ZStack {
                            Color.clear
                            ProgressView()
                                .frame(width: 50, height: 50)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Text(details?.shortTitle ?? "Пустой title")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            else {
                Text("Не удалось загрузить детали")
                    .foregroundColor(.red)
                    .font(.footnote)
            }
        }
        .background(Color.gray)
        .padding()
        .task {
            isLoading = true
            details = await viewModel.fetchEvent(id: event.id)
            isLoading = false
        }
    }
}

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var events: [EventItem] = []
    
    init() {
        loadEvents()
    }
    
    func loadEvents() {
        let now = Int(Date().timeIntervalSince1970)
        let sevenDaysLater = now + (7 * 24 * 60 * 60)
        
        Task {
            do {
                let events = try await DataManager.shared.fetchEvents(
                    location: "msk",
                    actualSince: now,
                    actualUntil: sevenDaysLater
                )
                self.events = events
            } catch {
                print("ProfileViewModel Ошибка при загрузке событий")
                self.events = []
            }
        }
    }
    
    func fetchEvent(id: Int) async -> EventDetails? {
        do {
            return try await DataManager.shared.fetchEventDetails(eventId: id)
        } catch {
            print("не удалось загрузить event \(id) Ошибка: \(error)")
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
            return nil
        }
    }
}
