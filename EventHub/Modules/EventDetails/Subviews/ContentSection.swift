//
//  ContentSection.swift
//  EventHub
//
//  Created by Николай Игнатов on 10.09.2025.
//

import SwiftUI

struct ContentSection: View {
    let eventDetails: EventDetailsModel
    let onReadMoreTapped: () -> Void
    let hasReadMoreURL: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            
            VStack(alignment: .leading) {
                Text(eventDetails.title)
                    .font(.title)
                    .fontWeight(.regular)
                    .foregroundColor(.black)
                
                Spacer()
                    .frame(height: 38)
                
                VStack(alignment: .leading, spacing: 16) {
                    InfoRow(
                        leftIcon: .icon(.calendar),
                        title: eventDetails.date,
                        subtitle: eventDetails.timeRange
                    )

                    InfoRow(
                        leftIcon: .icon(.location),
                        title: eventDetails.venue,
                        subtitle: eventDetails.address
                    )

                    if eventDetails.hasOrganizer {
                        InfoRow(
                            leftIcon: .asyncImage(url: eventDetails.organizerImageURL ?? ""),
                            title: eventDetails.organizer,
                            subtitle: eventDetails.organizerTitle
                        )
                    }
                }
                
                Spacer()
                    .frame(height: 20)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("About Event")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(eventDetails.description)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.black)
                            .lineSpacing(10)
                            .lineLimit(3)
                        
                        if hasReadMoreURL {
                            Button(action: onReadMoreTapped) {
                                Text("Read More..")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.blue)
                                    .lineSpacing(10)
                            }
                        }
                    }
                }
            }
        }
        .background(Color.white)
    }
}

#Preview {
    ContentSection(
        eventDetails: .example,
        onReadMoreTapped: { print("Read more tapped") },
        hasReadMoreURL: true
    )
}
