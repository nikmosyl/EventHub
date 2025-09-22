//
//  NetworkImage.swift
//  EventHub
//
//  Created by nikita on 12.09.2025.
//

import SwiftUI

struct NetworkImage: View {
    let imageUrl: String
    
    var body: some View {
        AsyncImage(url: URL(string: imageUrl)) { image in
            image
                .resizable()
                .scaledToFill()
                .clipped()
        } placeholder: {
            ZStack {
                Color.clear
                CustomProgressView()
            }
        }
    }
}

#Preview {
    NetworkImage(imageUrl: "https://image.tmdb.org/t/p/w500/edv5CZvWj09upOsy2Y6IwDhK8bt.jpg")
        .frame(width: 120, height: 120)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 3)
        .padding()
}
