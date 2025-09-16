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
                                .foregroundColor(.primary)
                        }
                        .frame(width: 25, height: 25)
                        
                        Spacer()
                    }
                    
                    Text("Search")
                        .font(.system(size: 24, weight: .regular))
                        .foregroundColor(.primary)
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
            .background(Color.white)
            
            Spacer()
            
            if viewModel.searchResults.isEmpty || viewModel.searchText.isEmpty {
                SearchEmptyView()
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.searchResults, id: \.id) { event in
                            // TODO: replace cell
                            Text(event.title)
                        }
                    }
                    .padding(.vertical)
                }
            }
            
            Spacer()
        }
        .background(Color.white.ignoresSafeArea())
        .sheet(isPresented: $viewModel.showFilters) {
            EmptyView()
        }
    }
}

#Preview {
    SearchView()
}
