//
//  FilterButton.swift
//  EventHub
//
//  Created by nikita on 16.09.2025.
//

import SwiftUI

struct FilterButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: "line.3.horizontal.decrease.circle.fill")
                    .font(.system(size: 24, weight: .medium))
                
                Text("Filters")
                    .font(.system(size: 12, weight: .medium))
            }
            .foregroundColor(.white)
            .padding(.leading, 8)
            .padding(.trailing, 11)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.navBarSecondary)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 20) {
        FilterButton {
            print("Filter pressed")
        }
        
        HStack {
            CustomSearchBar(
                text: .constant(""),
                placeholder: "Search..."
            )
            
            FilterButton {
                print("Filter pressed")
            }
        }
        .padding()
    }
}
