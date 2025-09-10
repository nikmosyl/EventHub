//
//  HeaderSection.swift
//  EventHub
//
//  Created by Николай Игнатов on 10.09.2025.
//

import SwiftUI

struct HeaderSection: View {
    let backgroundImageURL: String?
    let onBackTapped: () -> Void
    let onBookmarkTapped: () -> Void
    let isBookmarked: Bool
    let shareURL: URL?
    let isModal: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            AsyncImage(url: URL(string: backgroundImageURL ?? "")) {
                $0
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                LinearGradient(
                    colors: [Color.red.opacity(0.8), Color.orange.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
            .clipped()
            
            VStack {
                HStack {
                    HStack {
                        Button(action: onBackTapped) {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white) .font(.title2)
                                .fontWeight(.medium)
                        }
                        
                        Text("Event Details")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    ActionButton(
                        icon: .bookmark,
                        isSelected: isBookmarked,
                        selectedColor: .red,
                        action: onBookmarkTapped
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, isModal ? 20 : 60)
                
                Spacer()
                
                if let shareURL = shareURL {
                    HStack {
                        Spacer()
                        
                        ShareLink(item: shareURL) {
                            Image(.share)
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .medium))
                                .frame(width: 36, height: 36)
                                .background(.ultraThinMaterial.opacity(0.3))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
        }
        .frame(height: 220)
    }
}

#Preview {
    HeaderSection(
        backgroundImageURL: nil,
        onBackTapped: { print("Back tapped") },
        onBookmarkTapped: { print("Bookmark tapped") },
        isBookmarked: false,
        shareURL: URL(string: "https://google.com"),
        isModal: false
    )
}
