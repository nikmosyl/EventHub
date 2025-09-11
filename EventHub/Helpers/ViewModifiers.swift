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
