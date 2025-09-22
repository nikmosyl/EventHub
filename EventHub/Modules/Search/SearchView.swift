//
//  SearchView.swift
//  EventHub
//
//  Created by nikita on 16.09.2025.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 16) {
                ZStack {
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "arrow.left")
                                .foregroundColor(Color.textDarkPrimary)
                        }
                        .frame(width: 25, height: 25)
                        
                        Spacer()
                    }
                    
                    Text("Search")
                        .font(.system(size: 24, weight: .regular))
                        .foregroundColor(Color.textDarkPrimary)
                }
                
                HStack(spacing: 12) {
                    CustomSearchBar(
                        text: $viewModel.searchText,
                        placeholder: "Search..."
                    )
                    
                    FilterButton {
                        viewModel.showFilters.toggle()
                    }
                }
            }
            .padding(.top, 16)
            .padding(.horizontal, 24)
            .background(Color.background)
            
            Spacer()
            
            switch viewModel.viewState {
            case .empty:
                SearchEmptyView()
            case .loading:
                CustomProgressView()
            case .loaded(let events):
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(events) { event in
                            EventCellView(event: event)
                                .padding(.horizontal, 24)
                        }
                    }
                    .safeAreaInset(edge: .top) {
                        Color.clear.frame(height: 20)
                    }
                }
            case .error(let message):
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                    Text("Error: \(message)")
                        .font(.body)
                        .foregroundColor(.textDarkSecondary)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .background(Color.background.ignoresSafeArea())
        .sheet(isPresented: $viewModel.showFilters) {
            EmptyView()
        }
    }
}

#Preview {
    SearchView()
}
