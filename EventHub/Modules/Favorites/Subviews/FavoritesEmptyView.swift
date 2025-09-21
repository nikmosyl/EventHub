//
//  FavoritesEmptyView.swift
//  EventHub
//
//  Created by Николай Игнатов on 17.09.2025.
//

import SwiftUI

struct FavoritesEmptyView: View {
    let refresh: () -> ()
    
    var body: some View {
        VStack(spacing: 50) {
            Spacer()
            
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
            
            Button {
                refresh()
            } label: {
                Image(systemName: "arrow.clockwise.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.buttonColored)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    FavoritesEmptyView(refresh: {})
}
