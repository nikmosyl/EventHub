//
//  CategoryModel.swift
//  EventHub
//
//  Created by Drolllted on 16.09.2025.
//

import Foundation
import SwiftUI

struct CategoryModel: Identifiable {
    let id: Int
    let name: String
    let icon: String
    let color: Color
    
    init(category: EventCategory) {
        self.id = category.id ?? 0
        self.name = category.name ?? "Unknown"
        self.icon = CategoryIconCarousel.icon(for: category.name ?? "Unknown")
        self.color = CategoryColorCarousel.color(for: category.name ?? "Unknown")
    }
}
