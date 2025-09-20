//
//  VariableSectionView.swift
//  EventHub
//
//  Created by Drolllted on 10.09.2025.
//

import SwiftUI

struct VariableSectionView: View {
    
    let categories: [CategoryModel]
    @Binding var excludedCategoryIds: Set<Int>
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.id) { category in
                    Button {
                        if excludedCategoryIds.contains(category.id) {
                            excludedCategoryIds.remove(category.id)
                        } else {
                            excludedCategoryIds.insert(category.id)
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: category.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                                .foregroundColor(excludedCategoryIds.contains(category.id) ? category.color : .white)
                            
                            Text(category.name)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(excludedCategoryIds.contains(category.id) ? category.color : .white)
                                .lineLimit(1)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(excludedCategoryIds.contains(category.id) ? .white : category.color)
                        )
                        .overlay(
                            Capsule()
                                .stroke(excludedCategoryIds.contains(category.id) ? category.color.opacity(0.3) : Color.clear, lineWidth: 1)
                        )
                        .shadow(
                            color: excludedCategoryIds.contains(category.id) ? .black.opacity(0.1) : .clear,
                            radius: 3,
                            x: 0,
                            y: 2
                        )
                        .fixedSize()
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}
