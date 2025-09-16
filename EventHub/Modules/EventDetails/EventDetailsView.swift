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
    
    init(eventId: Int) {
        _viewModel = StateObject(wrappedValue: EventDetailsViewModel(eventId: eventId))
    }
    
    init(event: Event) {
        _viewModel = StateObject(wrappedValue: EventDetailsViewModel(event: event))
    }
    
    var body: some View {
        if viewModel.isLoading {
            ProgressView("Loading event details...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let eventDetails = viewModel.eventDetails {
            ZStack(alignment: .top) {
                ScrollView {
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: 220)
                        
                        ContentSection(
                            eventDetails: eventDetails,
                            onReadMoreTapped: viewModel.onReadMoreTapped
                        )
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
                
                HeaderSection(
                    backgroundImageURL: eventDetails.backgroundImageURL,
                    onBackTapped: { dismiss() },
                    onBookmarkTapped: viewModel.onBookmarkTapped,
                    isBookmarked: viewModel.isBookmarked,
                    shareURL: viewModel.shareURL
                )
            }
            .ignoresSafeArea(edges: .top)
        } else if let errorMessage = viewModel.errorMessage {
            VStack(spacing: 16) {
                Text("Error")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(errorMessage)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Button("Retry") {
                    viewModel.loadEventDetails()
                }
                .foregroundColor(.blue)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            Text("No event details available")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    EventDetailsView(eventId: 1)
}

