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
    let isBookmarking: Bool
    let shareURL: URL?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AsyncImage(url: URL(string: backgroundImageURL ?? "")) {
                    $0
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    LinearGradient(
                        colors: [Color.buttonPrimary, Color.buttonColored],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
                .frame(width: geometry.size.width, height: 220)
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
                        Button(action: onBookmarkTapped) {
                            if isBookmarking {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .frame(width: 36, height: 36)
                            } else {
                                Image(isBookmarked ? .bookmarkFill : .bookmark)
                                    .font(.system(size: 18, weight: .medium))
                                    .frame(width: 36, height: 36)
                            }
                        }
                        .disabled(isBookmarking)
                        .background(.ultraThinMaterial.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 56)
                    
                    Spacer()
                    
                    if let shareURL {
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
                .frame(width: geometry.size.width, height: 220)
            }
        }
        .frame(height: 220)
        .clipped()
    }
}

#Preview {
    HeaderSection(
        backgroundImageURL: nil,
        onBackTapped: { print("Back tapped") },
        onBookmarkTapped: { print("Bookmark tapped") },
        isBookmarked: false,
        isBookmarking: false,
        shareURL: URL(string: "https://google.com")
    )
}
