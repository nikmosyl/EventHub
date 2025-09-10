//
//  EventDetailsView.swift
//  EventHub
//
//  Created by Николай Игнатов on 10.09.2025.
//

import SwiftUI

struct EventDetailsView: View {
    @StateObject private var viewModel: EventDetailsViewModel
    
    init(eventDetails: EventDetailsModel, isModal: Bool = false) {
        _viewModel = StateObject(wrappedValue: EventDetailsViewModel(eventDetails: eventDetails, isModal: isModal))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderSection(
                backgroundImageURL: viewModel.eventDetails.backgroundImageURL,
                onBackTapped: viewModel.onBackTapped,
                onBookmarkTapped: viewModel.onBookmarkTapped,
                isBookmarked: viewModel.isBookmarked,
                shareURL: viewModel.shareURL,
                isModal: viewModel.isModal
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

