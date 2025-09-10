//
//  EventCellView.swift
//  EventHub
//
//  Created by Наташа Спиридонова on 10.09.2025.
//

import SwiftUI

struct EventCellView: View {
    @Binding var isBookmarked: Bool
    
    let imageURL: URL?
    let dataText: String
    let timeText: String
    let title: String
    let venue: String
    let city: String
    
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    placeholder
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure(_):
                    placeholder
                @unknown default:
                    placeholder
                }
            }
            .frame(width: 79, height: 92)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            
            VStack(alignment: .leading) {
                Text("\(dataText) • \(timeText)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.buttonPrimary)
                
                Text(title)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.textDarkPrimary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                    
                
                HStack {
                    Image(systemName: "location.circle")
                        .font(.subheadline)
                        .foregroundStyle(.textDarkSecondary)
                    
                    Text("\(venue) • \(city)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }
            
            Spacer()
            
            Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                .resizable()
                .frame(width: 17, height: 19)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.buttonCalored)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
        )
        .padding(.horizontal)
    }
    
    private var placeholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.backgroundSecondary)
            Image(systemName: "photo")
                .font(.title2)
                .foregroundStyle(.tertiary)
        }
    }
}

#Preview {
    EventCellView(
        isBookmarked: .constant(true),
        imageURL: nil,
        dataText: "Wed, Apr 28",
        timeText: "5:30 PM",
        title: "Jo Malone London’s Mother’s Day Presents",
        venue: "Radius Gallery",
        city: "Santa Cruz"
    )
}
