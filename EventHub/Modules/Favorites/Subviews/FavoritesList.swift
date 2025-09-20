//
//  FavoritesList.swift
//  EventHub
//
//  Created by Николай Игнатов on 17.09.2025.
//

import SwiftUI

struct FavoritesList: View {
    let events: [Event]
    let refresh: () -> ()

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                ForEach(events, id: \.id) { event in
                    EventCellView(event: event)
                }
            }
        }
        .refreshable {
            refresh()
        }
    }
}

#Preview {
    FavoritesList(events: [], refresh: {})
}
