//
//  ListCardView.swift
//  EventHub
//
//  Created by Наташа Спиридонова on 18.09.2025.
//


import SwiftUI

struct ListCardView: View {
    let title: String
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            // заголовок
            Text(title)
                .font(.system(size: 15))
                .fontWeight(.medium)
                .foregroundStyle(.textDarkPrimary)
                .lineLimit(2)
                .padding(.trailing, 24)
            // кнопка Read
            ReadButtonView(action: action)
        }
        .frame(width: 327,height: 106, alignment: .leading)
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.background)
        )
        .shadow(color: Color.secondary.opacity(0.5), radius: 16, x: 0, y: 10)
    }
}

#Preview {
    ListCardView(
        title: "Jo Malone London’s Mother’s Day Presents",
        action: {}
    )
}

