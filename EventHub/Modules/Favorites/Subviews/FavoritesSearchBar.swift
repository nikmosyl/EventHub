//
//  FavoritesSearchBar.swift
//  EventHub
//
//  Created by Николай Игнатов on 17.09.2025.
//

import SwiftUI

struct FavoritesSearchBar: View {
    @Binding var searchText: String
    let onSearchTextChange: () -> Void

    var body: some View {
        HStack {
            TextField("Search favorites...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: searchText) { _ in
                    onSearchTextChange()
                }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

#Preview {
    FavoritesSearchBar(searchText: .constant(""), onSearchTextChange: {})
}
