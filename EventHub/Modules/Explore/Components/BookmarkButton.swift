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
            Image(systemName: isLiked ? "bookmark.fill" : "bookmark")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 10, height: 5)
                .foregroundStyle(Color.buttonCalored)
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.textLightSecondary)
                        .frame(width: 30, height: 30)
                }
                .padding()
        }
    }
}
