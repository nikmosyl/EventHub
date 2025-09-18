//
//  ReadButton.swift
//  EventHub
//
//  Created by Наташа Спиридонова on 18.09.2025.
//


import SwiftUI

struct ReadButtonView: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Text("READ")
                    .font(.system(size: 16))
                    .fontWeight(.regular)
                    .foregroundStyle(.textLightPrimary)

                HStack {
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(.buttonSecondary)
                            .frame(width: 21, height: 19)
                        Image(systemName: "arrow.right")
                            .font(.system(size: 8))
                            .fontWeight(.semibold)
                            .foregroundStyle(.textLightPrimary)
                    }
                    .padding(.trailing, 8)
                }
            }
            .frame(width: 191, height: 36)
            .background(
                Capsule(style: .continuous)
                    .fill(.buttonPrimary)
            )
        }
        .buttonStyle(.plain)
        .contentShape(.rect)
//        .padding(.vertical, 4)
    }
}

#Preview {
    ReadButtonView(action: {})
}
