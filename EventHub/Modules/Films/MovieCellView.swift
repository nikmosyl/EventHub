//
//  MovieCellView.swift
//  EventHub
//
//  Created by Наташа Спиридонова on 22.09.2025.
//

import SwiftUI

struct MovieCellView: View {
    let poster: String
    let title: String
    let action: () -> Void

    var body: some View {
        HStack {
            // изображение
            NetworkImage(imageUrl: poster)
                .frame(width: 79, height: 92)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            VStack {
                // заголовок
                Text(title)
                    .font(.system(size: 15))
                    .fontWeight(.medium)
                    .foregroundStyle(.textDarkPrimary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                ReadButtonView(action: action)
                    .padding(.horizontal, 8)
                    .padding(.bottom, 8)
            }
        }
        .frame(width: 327,height: 106, alignment: .leading)
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.background)
        )
    }
}

#Preview {
    MovieCellView(poster: "", title: "CyberPunk 2077", action: {} )
}
