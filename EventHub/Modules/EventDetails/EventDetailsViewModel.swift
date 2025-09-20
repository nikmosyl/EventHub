//
//  EventDetailsViewModel.swift
//  EventHub
//
//  Created Created by Николай Игнатов on 10.09.2025.
//

import UIKit
import SwiftUI

@MainActor
final class EventDetailsViewModel: ObservableObject {
    @Published var eventDetails: EventDetailsModel?
    @Published var isBookmarked: Bool = false
    @Published var isBookmarking: Bool = false
    @Published var isLoading: Bool = false
    
    private let dataManager = DataManager.shared
    private let eventId: Int
    private(set) var event: Event
    
    var shareURL: URL? {
        event.siteUrl.flatMap(URL.init)
    }
    
    init(event: Event) {
        self.eventId = event.id ?? 0
        self.event = event
        self.eventDetails = EventDetailsModel(from: event)
        Task {
            do {
                self.isBookmarked = try await DataManager.shared.isEventfavorited(eventId: eventId)
            } catch {
                print("❌ не удалось загрузить favorite статус в Details для id: \(eventId), ошибка:", error)
            }
            
        }
    }
    
    func onBookmarkTapped() {
        Task {
            isBookmarking = true
            defer { isBookmarking = false }
            
            do {
                if let id = event.id {
                    if isBookmarked {
                        try await dataManager.removeFromFavorites(eventId: id)
                    } else {
                        try await dataManager.addToFavorites(eventId: id)
                    }
                    
                    isBookmarked.toggle()
                }
            } catch {
                print("Ошибка при изменении избранного: \(error)")
            }
        }
    }
    
    func onReadMoreTapped() {
        guard let siteUrl = event.siteUrl,
              let url = URL(string: siteUrl) else { return }
        UIApplication.shared.open(url)
    }
}
