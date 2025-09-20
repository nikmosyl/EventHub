//
//  InfoRow.swift
//  EventHub
//
//  Created by Николай Игнатов on 10.09.2025.
//

import SwiftUI

struct InfoRow: View {
    let leftIcon: InfoRowIcon
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            leftIconView
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
        }
    }
    
    @ViewBuilder
    private var leftIconView: some View {
        switch leftIcon {
        case .icon(let resource):
            Image(resource)
                .frame(width: 48, height: 48)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
        case .asyncImage(let url):
            AsyncImage(url: URL(string: url)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .background(Color.gray.opacity(0.1))
            }
            .frame(width: 48, height: 48)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

enum InfoRowIcon {
    case icon(_ resource: ImageResource)
    case asyncImage(url: String)
}

#Preview {
    VStack(alignment: .leading, spacing: 16) {
        InfoRow(
            leftIcon: .icon(.calendar),
            title: "14 December, 2021",
            subtitle: "Tuesday, 4:00PM - 9:00PM"
        )
        
        InfoRow(
            leftIcon: .icon(.location),
            title: "Gala Convention Center",
            subtitle: "36 Guild Street London, UK"
        )
        
        InfoRow(
            leftIcon: .asyncImage(url: ""),
            title: "Ashfak Sayem",
            subtitle: "Organizer"
        )
    }
    .padding()
}
