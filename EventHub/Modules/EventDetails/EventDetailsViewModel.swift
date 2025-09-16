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
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let dataManager = DataManager.shared
    private let eventId: Int
    private var event: Event?

    var shareURL: URL? {
        event?.siteUrl.flatMap(URL.init)
    }

    init(eventId: Int) {
        self.eventId = eventId
        loadEventDetails()
    }
    
    func loadEventDetails() {
        guard eventId > 0 else { return }

        isLoading = true
        errorMessage = nil

        Task {
            do {
                let foundEvent = try await dataManager.getEvent(id: eventId)
                event = foundEvent
                eventDetails = EventDetailsModel(from: foundEvent)
            } catch {
                errorMessage = "Failed to load event details: \(error.localizedDescription)"
            }
            isLoading = false
        }
    }

    func onBookmarkTapped() {
        // TODO: Implement bookmark functionality with DataManager
        isBookmarked.toggle()
    }
    
    func onReadMoreTapped() {
        guard let siteUrl = event?.siteUrl, 
              let url = URL(string: siteUrl) else { return }
        UIApplication.shared.open(url)
    }
}
