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
                        .frame(width: 218, height: 131)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.horizontal, 10)
                }else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 218, height: 131)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.horizontal, 10)
                }
                HStack {
                    
                    Text(events.formattedEventDate)
                        .font(.system(size: 16, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.textCalored)
                        .frame(width: 45, height: 45)
                        .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.textLightSecondary)
                                    .blur(radius: 1)
                        )
                        .padding(.leading, 20)
                        .padding(.top, 10)
                    
                    Spacer()
                    
                    BookmarkButton(action: {
                        //Сохранение мероприятия
                        isLiked.toggle()
                    }, isLiked: $isLiked)
                    .padding(.trailing, 15)
                    .padding(.top, 2)
                }
            }
            .frame(height: 131)
            .padding(.top, 20)
            
            
            VStack(alignment: .leading, spacing: 8) {
                
                Text(events.title ?? "Unknown")
                    .font(.system(size: 18, weight: .semibold))
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                
                HStack(spacing: 4) {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 12))
                    Text("\(events.participantCount) Going")
                        .font(.system(size: 12))
                }
                .foregroundColor(Color.tabBarTextPrimary)
                .padding(.horizontal, 16)
                
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 3) {
                        Image(systemName: "mappin")
                            .frame(width: 16, height: 16)
                        
                        Text(events.locationName)
                            .font(.system(size: 14))
                    }
                    .foregroundStyle(Color.textDarkSecondary)
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
