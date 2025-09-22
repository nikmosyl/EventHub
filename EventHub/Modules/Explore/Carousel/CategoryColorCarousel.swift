//
//  ColorCarousel.swift
//  EventHub
//
//  Created by Drolllted on 16.09.2025.
//

import Foundation
import SwiftUI

struct CategoryColorCarousel {
    static let colors: [Color] = [
        .pillColor1, .pillColor2, .pillColor3, .pillColor4
    ]
    
    private static var colorIndex: [String: Int] = [:]
    private static var currentIndex = 0
    
    static func color(for categoryName: String) -> Color {
        if let index = colorIndex[categoryName] {
            return colors[index]
        }
        let index = currentIndex
        colorIndex[categoryName] = index
        
        currentIndex = (currentIndex + 1) % colors.count
        
        return colors[index]
    }
}
