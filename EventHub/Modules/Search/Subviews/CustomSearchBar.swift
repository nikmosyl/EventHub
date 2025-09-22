//
//  CustomSearchBar.swift
//  EventHub
//
//  Created by nikita on 16.09.2025.
//

import SwiftUI

struct CustomSearchBar: View {
    @Binding var text: String
    let placeholder: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.navBarSecondary)
            
            Rectangle()
                .fill(Color.navBarSecondary)
                .frame(width: 1, height: 20)
            
            TextField(placeholder, text: $text)
                .font(.system(size: 16))
                .foregroundColor(Color.textDarkSecondary)
                .focused($isFocused)
                .submitLabel(.search)
        }
        .background(Color.background)
    }
}

#Preview {
    VStack(spacing: 20) {
        CustomSearchBar(
            text: .constant(""),
            placeholder: "Search..."
        )
        
        CustomSearchBar(
            text: .constant("Test search"),
            placeholder: "Search..."
        )
    }
    .padding()
}
