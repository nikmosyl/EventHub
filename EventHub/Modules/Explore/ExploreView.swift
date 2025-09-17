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
                        EventsCollectionView(title: "Upcomming Events", events: viewModel.getUpcommingViewModel())
                        EventsCollectionView(
                            title: "Nearby Events in \(viewModel.getCurrentLocationName())",
                            events: viewModel.getNearbyViewModel()
                        )
                    case .error(let error):
                        ErrorView(error: error) {
                            Task {
                                await viewModel.loadInitialData()
                            }
                        }
                    }
                    
                    if !viewModel.selectedCategoryIds.isEmpty {
                        Button {
                            Task {
                                await viewModel.loadEventsWithSelectedCategories()
                            }
                        } label: {
                            Text("Применить фильтр (\(viewModel.selectedCategoryIds.count))")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding()
                    }
                }
            }
            
            ExploreNavBar(
                categories: viewModel.getCategoryViewModel(),
                isSectionActive: $viewModel.selectedCategoryIds,
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
        .onReceive(viewModel.$selectedCategoryIds) { _ in
            Task {
                await viewModel.loadEventsWithSelectedCategories()
            }
        }
    }
}
