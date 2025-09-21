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
            ZStack {
                Text("Favorites")
                    .font(.system(size: 24))
                    .foregroundStyle(.textDarkPrimary)
                
                HStack {
                    Spacer()
                    
                    NavigationLink {
                        Text("Тут должен быть search")
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .frame(width: 18, height: 18)
                            .foregroundStyle(.textDarkPrimary)
                    }
                    
                }
            }
            .padding(.bottom, 16)
            
            switch viewModel.favoritesState {
            case .empty:
                FavoritesEmptyView(refresh: viewModel.loadFavorites)
                
            case .loading:
                FavoritesLoadingView()
                
            case .loaded:
                FavoritesList(
                    events: viewModel.favoriteEvents,
                    refresh: viewModel.loadFavorites
                )
                .tabSafeAreaPadding(40)
                
            case .error(let message):
                FavoritesErrorView(message: message, refresh: viewModel.loadFavorites)
            }
        }
        .onAppear {
            viewModel.loadFavorites()
        }
    }
}

#Preview {
    FavoritesView()
}
