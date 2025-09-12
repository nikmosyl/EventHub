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
    let action: () -> Void
    
    init(
        icon: ImageResource,
        selectedIcon: ImageResource? = nil,
        isSelected: Bool = false,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.selectedIcon = selectedIcon
        self.isSelected = isSelected
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image(isSelected ? (selectedIcon ?? icon) : icon)
                .foregroundColor(Color.textLightPrimary)
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
            ActionButton(icon: .bookmark) {
                print("Bookmark tapped")
            }
            
            ActionButton(icon: .bookmarkFill, isSelected: true) {
                print("Bookmark selected tapped")
            }
            
            ActionButton(icon: .share) {
                print("Share tapped")
            }
        }
    }
}
