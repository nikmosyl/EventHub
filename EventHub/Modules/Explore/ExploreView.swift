//
//  ExploreView.swift
//  EventHub
//
//  Created by Drolllted on 09.09.2025.
//

import SwiftUI

struct ExploreView: View {
    
    @StateObject var viewModel = ExploreViewModel()
    @State private var isSectionActive: Int?
    
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
                        EventsCollectionView(title: "Upcommning Events", events: viewModel.getUpcommingViewModel())
                        EventsCollectionView(title: "Nearby Events", events: viewModel.getNearbyViewModel())
                    case .error(let error):
                        ErrorView(error: error) {
                            Task {
                                await viewModel.loadInitialData()
                            }
                        }
                    }
                    
                    #warning("Не работает логика, которая сортирует по фильтрам и выводит только те события, которые удовлетворяют всем фильтрам")
                    
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
            ExploreNavBar(categories: viewModel.getCategoryViewModel(), isSectionActive: $viewModel.selectedCategoryIds)
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
