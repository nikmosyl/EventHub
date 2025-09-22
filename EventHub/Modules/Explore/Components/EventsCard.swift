//
//  EventsCard.swift
//  EventHub
//
//  Created by Drolllted on 09.09.2025.
//

import SwiftUI

struct EventsCard: View {
    
    @StateObject private var viewModel: EventCardViewModel
    let events: Event
    
    init(events: Event) {
        self.events = events
        self._viewModel = StateObject(wrappedValue: EventCardViewModel(event: events))
    }
    
    var body: some View {
        
        NavigationLink {
            EventDetailsView(event: events)
        } label: {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .top) {
                    
                    // Изображение события
                    if let imageURL = events.imageUrl {
                        NetworkImage(imageUrl: imageURL)
                            .frame(width: 218, height: 131)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 218, height: 131)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .foregroundColor(.gray.opacity(0.3))
                    }
                    
                    HStack {
                        Text(events.formattedEventDate)
                            .font(.system(size: 14, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.textCalored)
                            .frame(width: 45, height: 45)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.textLightSecondary)
                            )
                            .padding(.leading, 16)
                            .padding(.top, 12)
                        
                        Spacer()
                        
                        // Кнопка избранного
                        BookmarkButton(action: {
                            viewModel.eventsToggle()
                        }, isLiked: $viewModel.isLiked)
                        .padding(.trailing, 16)
                        .padding(.top, 12)
                    }
                }
                .frame(height: 131)
                .padding(.top, 12)
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text(events.title ?? "Unknown")
                        .font(.system(size: 16, weight: .semibold))
                        .lineLimit(2)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "person.2.fill")
                            .font(.system(size: 12))
                        Text("\(events.participantCount) Going")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(Color.tabBarTextPrimary)
                    
                    HStack(spacing: 6) {
                        Image("Map")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14, height: 14)
                            .foregroundColor(Color.textDarkSecondary)
                        
                        Text(events.locationName)
                            .font(.system(size: 12))
                            .lineLimit(1)
                            .foregroundColor(Color.textDarkSecondary)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
           .frame(width: 237, height: 255)
           .background(Color.background)
           .clipShape(RoundedRectangle(cornerRadius: 16))
           .overlay(
               RoundedRectangle(cornerRadius: 16)
                   .stroke(Color.shadow, lineWidth: 1)
           )
        }
    }
}
