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
                ProgressView()
            }
        }
    }
}
