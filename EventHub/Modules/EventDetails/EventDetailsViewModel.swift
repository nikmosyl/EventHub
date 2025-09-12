//
//  EventDetailsViewModel.swift
//  EventHub
//
//  Created Created by Николай Игнатов on 10.09.2025.
//

import UIKit
import SwiftUI

final class EventDetailsViewModel: ObservableObject {
    @Published var eventDetails: EventDetailsModel
    @Published var isBookmarked: Bool
    
    var shareURL: URL? {
        URL(string: "https://google.com")
    }
    
    init(eventDetails: EventDetailsModel, isBookmarked: Bool = false) {
        self.eventDetails = eventDetails
        self.isBookmarked = isBookmarked
    }
    
    func onBookmarkTapped() {
        print("Bookmark button tapped")
        isBookmarked.toggle()
    }
    
    
    func onReadMoreTapped() {
        print("Read more button tapped")
        if let url = URL(string: "https://google.com") {
            UIApplication.shared.open(url)
        }
    }
}
