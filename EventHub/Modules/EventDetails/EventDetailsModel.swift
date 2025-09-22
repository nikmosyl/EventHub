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
    let organizerImageURL: String?
    let backgroundImageURL: String?
    let hasOrganizer: Bool
    
    init(
        title: String,
        date: String,
        timeRange: String,
        venue: String,
        address: String,
        organizer: String,
        organizerTitle: String,
        description: String,
        organizerImageURL: String? = nil,
        backgroundImageURL: String? = nil,
        hasOrganizer: Bool = true
    ) {
        self.title = title
        self.date = date
        self.timeRange = timeRange
        self.venue = venue
        self.address = address
        self.organizer = organizer
        self.organizerTitle = organizerTitle
        self.description = description
        self.organizerImageURL = organizerImageURL
        self.backgroundImageURL = backgroundImageURL
        self.hasOrganizer = hasOrganizer
    }

    init(from event: Event) {
        self.title = event.title ?? "Event"

        if let firstDate = event.nextDate, let start = firstDate.start, start > 0 {
            self.date = firstDate.formatter(date: start, format: "dd MMMM, yyyy")

            if let end = firstDate.end, end > 0 {
                let startTime = firstDate.formatter(date: start, format: "HH:mm")
                let endTime = firstDate.formatter(date: end, format: "HH:mm")
                let dayName = firstDate.formatter(date: start, format: "EEEE")
                self.timeRange = "\(dayName), \(startTime) - \(endTime)"
            } else {
                self.timeRange = firstDate.formatter(date: start, format: "EEEE, HH:mm")
            }
        } else {
            self.date = "Date TBD"
            self.timeRange = "Time TBD"
        }

        self.venue = event.place?.title ?? "Venue TBD"
        self.address = event.place?.address ?? "Address TBD"

        if let firstParticipant = event.participants?.first?.agent {
            self.organizer = firstParticipant.title ?? "Unknown Organizer"
            self.organizerTitle = "Organizer"
            self.hasOrganizer = true
        } else {
            self.organizer = ""
            self.organizerTitle = ""
            self.hasOrganizer = false
        }

        // Clean HTML tags from description
        let rawDescription = event.description ?? "No description available"
        self.description = EventDetailsModel.cleanHTMLString(rawDescription)

        // Use participant image for organizer avatar, event image for background
        self.organizerImageURL = event.participants?.first?.agent?.images?.first
        self.backgroundImageURL = event.images?.first?.image
    }

    static func cleanHTMLString(_ htmlString: String) -> String {
        let cleanedString = htmlString.replacingOccurrences(
            of: "<[^>]+>",
            with: "",
            options: .regularExpression,
            range: nil
        )

        return cleanedString
            .replacingOccurrences(of: "&nbsp;", with: " ")
            .replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&lt;", with: "<")
            .replacingOccurrences(of: "&gt;", with: ">")
            .replacingOccurrences(of: "&quot;", with: "\"")
            .replacingOccurrences(of: "&#39;", with: "'")
            .trimmingCharacters(in: .whitespacesAndNewlines)
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
