//
//  VariableSectionView.swift
//  EventHub
//
//  Created by Drolllted on 10.09.2025.
//

import SwiftUI

struct VariableSectionView: View {
    let categories = ["Sports", "Music", "Food", "Art"]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    HStack(spacing: 6) {
                        Image(systemName: iconForCategories(catigories: category))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.white)
                        
                        Text(category)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                            .lineLimit(1)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(colorForCategories(categories: category))
                    )
                    .fixedSize()
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private func iconForCategories(catigories: String) -> String{
        switch catigories.lowercased() {
        case "sports" : return "basketball.fill"
        case "music" : return "music.note"
        case "food" : return "fork.knife"
        case "art" : return "photo.fill"
        default:
            return ""
        }
    }
    
    private func colorForCategories(categories: String) -> Color {
        switch categories.lowercased(){
        case "sports" : return Color.pillColor1
        case "music" : return Color.pillColor2
        case "food" : return Color.pillColor3
        case "art" : return Color.pillColor4
        
        default:
            return Color.background
        }
    }
}

#if DEBUG
#Preview{
    VariableSectionView()
}
#endif
