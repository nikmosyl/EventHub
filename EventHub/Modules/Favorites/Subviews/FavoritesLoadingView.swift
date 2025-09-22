//
//  FavoritesLoadingView.swift
//  EventHub
//
//  Created by Николай Игнатов on 17.09.2025.
//

import SwiftUI

struct FavoritesLoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            CustomProgressView()
                .scaleEffect(1.2)
                .progressViewStyle(CircularProgressViewStyle(tint: .buttonPrimary))

            Text("Loading favorites...")
                .font(.system(size: 16))
                .foregroundColor(.secondary)

            Spacer()
        }
    }
}

#Preview {
    FavoritesLoadingView()
}
