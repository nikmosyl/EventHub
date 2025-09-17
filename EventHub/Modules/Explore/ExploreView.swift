//
//  ExploreView.swift
//  EventHub
//
//  Created by Drolllted on 09.09.2025.
//

import SwiftUI

struct ExploreView: View {
    
    @StateObject var viewModel = ExploreViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    Spacer()
                        .frame(height: 140)
                    
                    switch viewModel.state {
                    case .idle, .loading:
                        ProgressView()
                            .frame(height: 200)
                    case .loaded(_):
                        EventsCollectionView(
                            title: "Upcomming Events",
                            events: viewModel.getUpcommingForExploreView(),
                            tapInSeeAllButton: {
                                #warning("Получать все ячейки Upcomming Events")
                                print(viewModel.getAllUpcomingEvents())
                            }
                        )
                        EventsCollectionView(
                            title: "Nearby Events",
                            events: viewModel.getNearbyEventsForExploreView(),
                            tapInSeeAllButton: {
                                #warning("Получать все ивенты, которые находятся рядом по городам")
                                print(viewModel.getAllNearbyEvents())
                            }
                        )
                    case .error(let error):
                        ErrorView(error: error)
                    }
                }
            }
            
            ExploreNavBar(
                categories: viewModel.getCategoryForExploreView(),
                excludedCategoryIds: $viewModel.excludedCategoryIds,
                currentLocationName: viewModel.getCurrentLocationName(),
                currentLocationSlug: viewModel.selectedLocation,
                availableLocations: viewModel.availableLocations,
                isLoadingLocations: viewModel.isLoadingLocations && viewModel.availableLocations.isEmpty
            ) { locationSlug in
                Task {
                    await viewModel.updateLocation(locationSlug)
                }
            }
        }
        .task {
            await viewModel.loadInitialData()
        }
    }
}
