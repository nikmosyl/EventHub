//
//  RoundedRectangleShape.swift
//  EventHub
//
//  Created by Анастасия Тихонова on 11.09.2025.
//
import SwiftUI


struct RoundedRectangleShape: Shape {
    let radius: CGFloat
    let corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(
                width: radius,
                height: radius
            )
        )
        return Path(path.cgPath)
    }
}
