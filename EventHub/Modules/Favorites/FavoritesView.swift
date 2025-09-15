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
        NavigationView {
            VStack(spacing: 0) {
                favoritesContent
            }
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // TODO: Implement search functionality
                    }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadFavorites()
        }
    }
}

// MARK: - Private Views
private extension FavoritesView {
    var loadingView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ProgressView()
                .scaleEffect(1.2)
                .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
            
            Text("Loading favorites...")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
    
    var emptyView: some View {
        VStack(spacing: 50) {
            Text("NO FAVORITES")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)
            
            Image(systemName: "bookmark")
                .font(.system(size: 120))
                .foregroundColor(.red.opacity(0.6))
                .overlay(
                    Image(systemName: "xmark")
                        .font(.system(size: 40, weight: .medium))
                        .foregroundColor(.red.opacity(0.6))
                        .offset(x: 0, y: -10)
                )
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    var favoritesContent: some View {
        switch viewModel.favoritesState {
        case .initial, .loading:
            loadingView
            
        case .empty:
            emptyView
            
        case .loaded(let events):
            favoritesList(events)
            
        case .error(let message):
            centerText(message)
        }
    }
}

// MARK: - Private Methods
private extension FavoritesView {
    func centerText(_ text: String) -> some View {
        VStack {
            Spacer()
            Text(text)
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    func favoritesList(_ events: [Event]) -> some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(events, id: \.id) { event in
                    //                    NavigationLink(destination: EventDetailsView(event: event)) {
                    //                        EventCell(event: event)
                    //                    }
                    //  .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    FavoritesView()
}
