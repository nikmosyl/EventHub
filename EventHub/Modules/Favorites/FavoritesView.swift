//
//  FavoritesView.swift
//  EventHub
//
//  Created by Николай Игнатов on 15.09.2025.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isSearching {
                FavoritesSearchBar(
                    searchText: $viewModel.searchText,
                    onSearchTextChange: viewModel.searchFavorites
                )
            }
            
            Spacer()
            
            favoritesContent
            
            Spacer()
        }
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: viewModel.toggleSearch) {
                    Image(systemName: viewModel.isSearching ? "xmark" : "magnifyingglass")
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

// MARK: - Private Views
private extension FavoritesView {
    @ViewBuilder
    var favoritesContent: some View {
        switch viewModel.favoritesState {
        case .empty:
            FavoritesEmptyView()
            
        case .loading:
            FavoritesLoadingView()
            
        case .loaded(let events):
            FavoritesList(events: events, refresh: viewModel.loadFavorites)
            
        case .error(let message):
            FavoritesErrorView(message: message)
        }
    }
}

#Preview {
    FavoritesView()
}
