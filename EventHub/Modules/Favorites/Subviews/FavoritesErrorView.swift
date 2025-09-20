//
//  FavoritesErrorView.swift
//  EventHub
//
//  Created by Николай Игнатов on 17.09.2025.
//

import SwiftUI

struct FavoritesErrorView: View {
    let message: String
    let refresh: () -> ()

    var body: some View {
        VStack {
            Spacer()
            
            Text(message)
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button {
                refresh()
            } label: {
                Image(systemName: "arrow.clockwise.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.buttonPrimary)
            }

            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    FavoritesErrorView(message: "Failed to load favorites", refresh: {})
}
