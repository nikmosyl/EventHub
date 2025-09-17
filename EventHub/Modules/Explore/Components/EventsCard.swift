//
//  EventsCard.swift
//  EventHub
//
//  Created by Drolllted on 09.09.2025.
//

import SwiftUI

struct EventsCard: View {
    
    @State private var isLiked: Bool = false
    let events: Event
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .top) {
                
                if let imageURL = events.imageUrl {
                    NetworkImage(imageUrl: imageURL)
                        .frame(width: 217, height: 140)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.horizontal, 10)
                }else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 217, height: 140)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.horizontal, 10)
                }
                HStack {
                    
                    Text(events.formattedDate)
                        .font(.system(size: 16, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.textCalored)
                        .frame(width: 60, height: 60)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.textLightSecondary)
                                .frame(width: 60, height: 60)
                        )
                        .padding(.leading, 15)
                        .padding(.top, 5)
                    
                    Spacer()
                    
                    BookmarkButton(action: {
                        //Сохранение мероприятия
                        isLiked.toggle()
                    }, isLiked: $isLiked)
                        .padding(.trailing, 15)
                        .padding(.top, 2)
                }
            }
            .frame(height: 140)
            .padding(.top, 20)
            
            
            VStack(alignment: .leading, spacing: 8) {
                
                Text(events.title)
                    .font(.system(size: 16, weight: .semibold))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                
                
                if events.participantCount > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "person.2.fill")
                            .font(.system(size: 12))
                        Text(events.formattedParticipantCount)
                            .font(.system(size: 12))
                    }
                    .foregroundColor(.pillColor3)
                    .padding(.horizontal, 16)
                }
                
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(events.locationName)
                        .font(.system(size: 14))
                    Text(events.formattedPrice)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
            .frame(height: 115)
            .background(Color.white)
        }
        .frame(width: 237, height: 255)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.black.opacity(0.1), lineWidth: 1)
        )
    }
}
