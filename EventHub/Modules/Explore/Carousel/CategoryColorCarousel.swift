//
//  ColorCarousel.swift
//  EventHub
//
//  Created by Drolllted on 16.09.2025.
//

import Foundation
import SwiftUI

struct CategoryColorCarousel{
    static let colors: [Color] = [
        .blue, .green, .red, .orange, .purple, .pink, 
        .yellow, .teal, .indigo, .mint, .cyan, .brown
    ]
    
    static func color(for categoryName: String) -> Color {
        let index = abs(categoryName.hashValue) % colors.count
        return colors[index]
    }
}
