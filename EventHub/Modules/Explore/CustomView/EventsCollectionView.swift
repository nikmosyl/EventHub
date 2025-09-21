//
//  EventsView.swift
//  EventHub
//
//  Created by Drolllted on 14.09.2025.
//

import SwiftUI

struct EventsCollectionView: View {
    let title: String
    let events: [Event]
    let tapInSeeAllButton: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.textDarkPrimary)
                Spacer()
                
                Button("See All") {
                   tapInSeeAllButton()
                }
                .font(.system(size: 14))
                .foregroundStyle(Color.textDarkSecondary)
            }
            .padding(.horizontal, 15)
            
            // Контейнер с фиксированной высотой для контента
            ZStack {
                if events.isEmpty {
                    // Сообщение о отсутствии событий
                    Text("Events not Found")
                        .font(.system(size: 16))
                        .foregroundColor(.textDarkSecondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.clear)
                } else {
                    // Список событий
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(events, id: \.id) { event in
                                EventsCard(events: event)
                                    .padding(.vertical, 5)
                            }
                        }
                        .padding(.horizontal, 15)
                    }
                }
            }
            
        }
    }
}
