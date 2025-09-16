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
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.textDarkPrimary)
                
                Spacer()
                
                Button("See All") {
                    // Navigation to all events
                }
                .font(.system(size: 14))
                .foregroundStyle(Color.textDarkSecondary)
            }
            .padding(.horizontal, 15)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(events, id: \.id) { event in
                        EventsCard(events: event)
                    }
                }
            }
        }
    }
}
