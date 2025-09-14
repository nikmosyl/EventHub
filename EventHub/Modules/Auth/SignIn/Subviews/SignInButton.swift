//
//  SignInButton.swift
//  EventHub
//
//  Created by Mikhail Ustyantsev on 09.09.2025.
//

import SwiftUI

struct SignInButton: View {
    let backgroundColor: Color
    let circleColor: Color
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .regular))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
                .frame(maxWidth: .infinity)
        }
        .overlay(alignment: .trailing) {
            Circle()
                .fill(circleColor)
                .frame(width: 36, height: 36)
                .overlay(
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                )
                .padding(.trailing, 20)
        }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    var height: CGFloat = 58
    var cornerRadius: CGFloat = 16

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(maxWidth: .infinity, minHeight: height)
            .contentShape(RoundedRectangle(cornerRadius: cornerRadius))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
