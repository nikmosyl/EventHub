//
//  VariableSectionView.swift
//  EventHub
//
//  Created by Drolllted on 10.09.2025.
//

import SwiftUI

struct VariableSectionView: View {
    
    let categories: [CategoryModel]
    @Binding var selectedCategoryIds: Set<Int>
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.id) { category in
                    Button {
                        if selectedCategoryIds.contains(category.id) {
                            selectedCategoryIds.remove(category.id)
                        } else {
                            selectedCategoryIds.insert(category.id)
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: category.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                                .foregroundColor(selectedCategoryIds.contains(category.id) ? .white : category.color)
                            
                            Text(category.name)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(selectedCategoryIds.contains(category.id) ? .white : category.color)
                                .lineLimit(1)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(selectedCategoryIds.contains(category.id) ? category.color : .white)
                        )
                        .overlay(
                            Capsule()
                                .stroke(selectedCategoryIds.contains(category.id) ? category.color.opacity(0.3) : Color.gray.opacity(0.2), lineWidth: 1)
                        )
                        .shadow(
                            color: .shadow,
                            radius: 2,
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
