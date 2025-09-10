//
//  EventDetailsModel.swift
//  EventHub
//
//  Created by Николай Игнатов on 10.09.2025.
//

import Foundation

struct EventDetailsModel {
    let title: String
    let date: String
    let timeRange: String
    let venue: String
    let address: String
    let organizer: String
    let organizerTitle: String
    let description: String
    let imageURL: String?
    let backgroundImageURL: String?
    
    init(
        title: String,
        date: String,
        timeRange: String,
        venue: String,
        address: String,
        organizer: String,
        organizerTitle: String,
        description: String,
        imageURL: String? = nil,
        backgroundImageURL: String? = nil
    ) {
        self.title = title
        self.date = date
        self.timeRange = timeRange
        self.venue = venue
        self.address = address
        self.organizer = organizer
        self.organizerTitle = organizerTitle
        self.description = description
        self.imageURL = imageURL
        self.backgroundImageURL = backgroundImageURL
    }
    
    static let example = EventDetailsModel(
        title: "International Band Music Concert",
        date: "14 December, 2021",
        timeRange: "Tuesday, 4:00PM - 9:00PM",
        venue: "Gala Convention Center",
        address: "36 Guild Street London, UK",
        organizer: "Ashfak Sayem",
        organizerTitle: "Organizer",
        description: "Enjoy your favorite dishe and a lovely your friends and family and have a great time. Food from local food trucks will be available for purchase."
    )
}
