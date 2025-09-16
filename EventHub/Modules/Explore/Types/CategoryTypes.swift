//
//  CategoryTypes.swift
//  EventHub
//
//  Created by Drolllted on 16.09.2025.
//

import Foundation
import SwiftUI

enum CategoryTypes: String, CaseIterable{
    case sport
    case music
    case art
    case cinema
    case theater
    case dance
    case food
    case science
    case technology
    case education
    case business
    case health
    case fashion
    case travel
    case kids
    case charity
    case other
    
    var systemIcon: String {
        switch self {
        case .sport:
            return "sportscourt"
        case .music:
            return "music.note"
        case .art:
            return "paintpalette"
        case .cinema:
            return "film"
        case .theater:
            return "theatermasks"
        case .dance:
            return "figure.socialdance"
        case .food:
            return "fork.knife"
        case .science:
            return "atom"
        case .technology:
            return "desktopcomputer"
        case .education:
            return "book.closed"
        case .business:
            return "briefcase"
        case .health:
            return "cross.case"
        case .fashion:
            return "tshirt"
        case .travel:
            return "airplane"
        case .kids:
            return "figure.2.and.child.holdinghands"
        case .charity:
            return "heart"
        case .other:
            return "square.grid.2x2"
        }
    }
    
    var color: Color {
        switch self{
            
        case .sport:
            return Color.pillColor1
        case .music:
            return Color.pillColor2
        case .art:
            return Color.pillColor3
        case .cinema:
            return Color.pillColor4
        case .theater:
            return Color.buttonSecondary
        case .dance:
            return Color.pillColor1
        case .food:
            return Color.pillColor2
        case .science:
            return Color.pillColor3
        case .technology:
            return Color.pillColor4
        case .education:
            return Color.buttonCalored
        case .business:
            return Color.pillColor1
        case .health:
            return Color.pillColor2
        case .fashion:
            return Color.pillColor3
        case .travel:
            return Color.pillColor4
        case .kids:
            return Color.buttonSecondary
        case .charity:
            return Color.buttonCalored
        case .other:
            return Color.blue
        }
    }
    
    static func from(name: String) -> CategoryTypes {
        let lowercased = name.lowercased()
        
        for category in CategoryTypes.allCases {
            if lowercased.contains(category.rawValue) {
                return category
            }
        }
        
        // Дополнительные проверки для русского языка
        if lowercased.contains("спорт") { return .sport }
        if lowercased.contains("музык") { return .music }
        if lowercased.contains("искусств") { return .art }
        if lowercased.contains("кино") { return .cinema }
        if lowercased.contains("театр") { return .theater }
        if lowercased.contains("танц") { return .dance }
        if lowercased.contains("еда") { return .food }
        if lowercased.contains("наука") { return .science }
        if lowercased.contains("технолог") { return .technology }
        if lowercased.contains("образован") { return .education }
        if lowercased.contains("бизнес") { return .business }
        if lowercased.contains("здоров") { return .health }
        if lowercased.contains("мода") { return .fashion }
        if lowercased.contains("путешеств") { return .travel }
        if lowercased.contains("детск") { return .kids }
        if lowercased.contains("благотворительн") { return .charity }
        
        return .other
        
    }
}
