//
//  VariableSectionView.swift
//  EventHub
//
//  Created by Drolllted on 10.09.2025.
//

import SwiftUI

struct VariableSectionView: View {
    
    let categories: [CategoryModel]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.id) { category in
                    HStack(spacing: 6) {
                        Image(systemName: category.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.white)
                        
                        Text(category.name)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                            .lineLimit(1)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(category.color)
                    )
                    .fixedSize()
                }
            }
            .padding(.horizontal, 16)
        }
     }
}
