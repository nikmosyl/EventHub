//
//  ListsView.swift
//  EventHub
//
//  Created by Наташа Спиридонова on 19.09.2025.
//

import SwiftUI

struct ListsView: View {
    private let items: [ListItem] = [
        .init(id: 1, publicationDate: nil, title: "Jo Malone London’s Mother’s Day\nPresents", slug: nil, siteUrl: nil),
        .init(id: 2, publicationDate: nil, title: "The Best Brunch Spots in the City", slug: nil, siteUrl: nil),
        .init(id: 3, publicationDate: nil, title: "Top 10 Exhibitions This Week", slug: nil, siteUrl: nil)
    ]
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(items) { item in
                    ListCardView(title: item.title ?? "Без названия") {
                        
                    }
                }
            }
        }
        .background(Color.background.ignoresSafeArea())
        .navigationTitle("Lists")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { /* поиск */ }) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.textDarkPrimary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ListsView()
    }
}
