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
    let allEvents: [Event]
    
    var body: some View {
        VStack(spacing: 1) {
            HStack {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.textDarkPrimary)
                    .frame(height: 34)
                Spacer()
                
                NavigationLink {
                    SeeAllView(events: allEvents)
                } label: {
                    Text("See All")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.textDarkSecondary)
                }
            }
            .padding(.horizontal, 15)
            
            ZStack {
                if events.isEmpty {
                    Text("Events not Found")
                        .font(.system(size: 16))
                        .foregroundColor(.textDarkSecondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.clear)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(events, id: \.id) { event in
                                EventsCard(events: event)
                                    .padding(.vertical, 5)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
            
        }
    }
}
