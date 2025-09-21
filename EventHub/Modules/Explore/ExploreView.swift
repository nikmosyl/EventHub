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
                        .frame(height: 200)
                    
                    switch viewModel.state {
                    case .idle, .loading:
                        ProgressView()
                            .frame(height: 200)
                    case .loaded(_):
                        EventsCollectionView(
                            title: "Upcomming Events",
                            events: viewModel.getUpcommingForExploreView(),
                            tapInSeeAllButton: {
                                // Переход на экран со всеми событиями
                            }
                        )
                        EventsCollectionView(
                            title: "Nearby Events",
                            events: viewModel.getNearbyEventsForExploreView(),
                            tapInSeeAllButton: {
                                // Переход на экран с nearby событиями
                            }
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
                await viewModel.refreshData()
            }
            .tint(Color.blue)
            
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
                },
                todayEvent: {
                    viewModel.showTodayEvents()
                },
                filmsEvent: {
                    viewModel.showFilms()
                },
                listsEvent: {
                    // Переход на экран списков
                },
                showOnlyToday: $viewModel.showOnlyTodayEvents,
                showOnlyFilms: $viewModel.showOnlyFilms
            )
        }
        .task {
            await viewModel.loadInitialData()
        }
    }
}
