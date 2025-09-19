//
//  FavoritesEmptyView.swift
//  EventHub
//
//  Created by Николай Игнатов on 17.09.2025.
//

import SwiftUI

struct FavoritesEmptyView: View {
    var body: some View {
        VStack(spacing: 50) {
            Text("NO FAVORITES")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)

            Image(systemName: "bookmark")
                .font(.system(size: 120))
                .foregroundColor(.red.opacity(0.6))
                .overlay(
                    Image(systemName: "xmark")
                        .font(.system(size: 40, weight: .medium))
                        .foregroundColor(.red.opacity(0.6))
                        .offset(x: 0, y: -10)
                )
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    FavoritesEmptyView()
}
