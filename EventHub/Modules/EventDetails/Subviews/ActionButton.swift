//
//  ActionButton.swift
//  EventHub
//
//  Created by Николай Игнатов on 10.09.2025.
//

import SwiftUI

struct ActionButton: View {
    let icon: ImageResource
    let selectedIcon: ImageResource?
    let isSelected: Bool
    let selectedColor: Color?
    let action: () -> Void
    
    init(
        icon: ImageResource,
        selectedIcon: ImageResource? = nil,
        isSelected: Bool = false,
        selectedColor: Color? = nil,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.selectedIcon = selectedIcon
        self.isSelected = isSelected
        self.selectedColor = selectedColor
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image(isSelected ? (selectedIcon ?? icon) : icon)
                .renderingMode(.template)
                .foregroundColor(isSelected && selectedColor != nil ? selectedColor! : .white)
                .font(.system(size: 18, weight: .medium))
                .frame(width: 36, height: 36)
                .background(.ultraThinMaterial.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    ZStack {
        Color.black
        VStack(spacing: 20) {
            ActionButton(icon: .bookmark, selectedColor: .red) {
                print("Bookmark tapped")
            }
            
            ActionButton(icon: .bookmark, isSelected: true, selectedColor: .red) {
                print("Bookmark selected tapped")
            }
            
            ActionButton(icon: .share) {
                print("Share tapped")
            }
        }
    }
}
