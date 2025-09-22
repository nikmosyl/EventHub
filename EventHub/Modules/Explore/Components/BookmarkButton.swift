//
//  BookmarkButton.swift
//  EventHub
//
//  Created by Drolllted on 10.09.2025.
//

import SwiftUI

struct BookmarkButton: View {
    
    let action: () -> Void
    @Binding var isLiked: Bool
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(isLiked ? "bookmark.fill" : "bookmark-1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 14, height: 14)
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.textLightSecondary)
                        .frame(width: 30, height: 30)
                }
                .padding()
        }
    }
}
