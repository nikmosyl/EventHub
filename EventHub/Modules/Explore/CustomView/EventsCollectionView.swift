//
//  EventsView.swift
//  EventHub
//
//  Created by Drolllted on 14.09.2025.
//

import SwiftUI


struct EventsCollectionView: View {
    
    @EnvironmentObject var viewModel : ExploreViewModel
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text("Upcoming Events")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.textDarkPrimary)
                Spacer()
                
                Button {
                    // Navigation to all upcoming events
                } label: {
                    Text("See All")
                        .foregroundStyle(Color.textDarkSecondary)
                        .font(.system(size: 14))
                }
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(viewModel.getUpcommnigViewModel()) { event in
                        EventsCard(events: event)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        
        // Nearby Events Section
        VStack(spacing: 5) {
            HStack {
                Text("Nearby Events")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.textDarkPrimary)
                Spacer()
                
                Button {
                    // Navigation to all nearby events
                } label: {
                    Text("See All")
                        .foregroundStyle(Color.textDarkSecondary)
                        .font(.system(size: 14))
                }
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(viewModel.getNearbyViewModel()) { event in
                        EventsCard(events: event)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}
