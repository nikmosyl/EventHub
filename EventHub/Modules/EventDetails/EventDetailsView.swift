//
//  EventDetailsView.swift
//  EventHub
//
//  Created by Николай Игнатов on 10.09.2025.
//

import SwiftUI

struct EventDetailsView: View {
    @StateObject private var viewModel: EventDetailsViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(eventDetails: EventDetailsModel, isBookmarked: Bool = false) {
        _viewModel = StateObject(wrappedValue: EventDetailsViewModel(eventDetails: eventDetails, isBookmarked: isBookmarked))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderSection(
                backgroundImageURL: viewModel.eventDetails.backgroundImageURL,
                onBackTapped: { dismiss() },
                onBookmarkTapped: viewModel.onBookmarkTapped,
                isBookmarked: viewModel.isBookmarked,
                shareURL: viewModel.shareURL
            )
            ScrollView {
                ContentSection(
                    eventDetails: viewModel.eventDetails,
                    onReadMoreTapped: viewModel.onReadMoreTapped
                )
                .padding(.horizontal, 20)
            }
        }
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    EventDetailsView(eventDetails: .example)
}

