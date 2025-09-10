//
//  VariableSectionView.swift
//  EventHub
//
//  Created by Drolllted on 10.09.2025.
//

import SwiftUI

struct VariableSectionView: View {
    let categories = ["Sports", "Music", "Food", "Art", "Tech", "Business"]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    Text(category)
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(Color.blue.opacity(0.8))
                        )
                }
            }
        }
    }
}

#if DEBUG
#Preview{
    VariableSectionView()
}
#endif
