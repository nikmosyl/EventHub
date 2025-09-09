//
//  ViewModifiers.swift
//  EventHub
//
//  Created by Mikhail Ustyantsev on 10.09.2025.
//

import SwiftUI

struct FilledButtonBackground: ViewModifier {
    let color: Color
    let cornerRadius: CGFloat
    func body(content: Content) -> some View {
        content
            .background(RoundedRectangle(cornerRadius: cornerRadius).fill(color))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}
extension View {
    func filledButtonBackground(_ color: Color, cornerRadius: CGFloat = 16) -> some View {
        modifier(FilledButtonBackground(color: color, cornerRadius: cornerRadius))
    }
}
