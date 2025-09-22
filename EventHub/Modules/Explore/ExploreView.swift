//
//  ExploreView.swift
//  EventHub
//
//  Created by Drolllted on 09.09.2025.
//

import SwiftUI

struct ExploreView: View {
    @StateObject var viewModel = ExploreViewModel()
    
    @State private var isRefreshing = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.background
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    Spacer()
                        .frame(height: 160)
                    
                    ProButtons(location: viewModel.selectedLocation)
                    
                    switch viewModel.state {
                    case .idle, .loading:
                        ProgressView()
                            .frame(height: 200)
                    case .loaded(_):
                        EventsCollectionView(
                            title: "Upcomming Events",
                            events: viewModel.getUpcommingForExploreView(),
                            allEvents: viewModel.upcommingEvents
                        )
                        EventsCollectionView(
                            title: "Nearby Events",
                            events: viewModel.getNearbyEventsForExploreView(),
                            allEvents: viewModel.nearbyEvents
                        )
                    case .error(let error):
                        ErrorView(error: error) {
                            Task {
                                await viewModel.refreshData()
                            }
                        }
                    }
                }
            }
            .refreshable {
                isRefreshing = true
                await viewModel.refreshData()
                isRefreshing = false
            }

            ExploreNavBar(
                categories: viewModel.getCategoryForExploreView(),
                selectedCategoryIds: $viewModel.selectedCategoryIds,
                currentLocationName: viewModel.getCurrentLocationName(),
                currentLocationSlug: viewModel.selectedLocation,
                availableLocations: viewModel.availableLocations,
                isLoadingLocations: viewModel.isLoadingLocations && viewModel.availableLocations.isEmpty,
                onLocationSelect: { locationSlug in
                    Task {
                        await viewModel.updateLocation(locationSlug)
                    }
                })
        }
        .task {
            await viewModel.loadInitialData()
        }
    }
}
