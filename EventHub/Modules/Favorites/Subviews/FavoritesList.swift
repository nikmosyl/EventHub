//
//  FavoritesList.swift
//  EventHub
//
//  Created by Николай Игнатов on 17.09.2025.
//

import SwiftUI

struct FavoritesList: View {
    let events: [Event]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(events, id: \.id) { event in
                    EventCellView(event: event)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    FavoritesList(events: [])
}
