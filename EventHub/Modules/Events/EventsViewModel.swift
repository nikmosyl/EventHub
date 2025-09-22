//
//  EventsViewModel.swift
//  EventHub
//
//  Created by nikita on 22.09.2025.
//

import Foundation

@MainActor
final class EventsViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var upcoming = true
    
    init() {
        Task {
            await loadUpcoming()
        }
    }
    
    func loadUpcoming() async {
        do {
            events = try await DataManager.shared.getUpcamingEvents(location: "")
        } catch {
            print("не удалось загрузить Upcoming", error)
        }
    }
    
    func loadPast() async {
        do {
            events = try await DataManager.shared.getPastEvents(location: "")
        } catch {
            print("не удалось загрузить Upcoming", error)
        }
    }
    
    func toggleSwitch() {
        events = []
        Task {
            if upcoming {
                await loadUpcoming()
            } else {
                await loadPast()
            }
        }
    }
}
