//
//  RoundedRectangleShape.swift
//  EventHub
//
//  Created by Drolllted on 09.09.2025.
//

import SwiftUI

struct RoundedRectangleShape: Shape {
    let radius: CGFloat
    let corners: UIRectCorner
    
    nonisolated func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
