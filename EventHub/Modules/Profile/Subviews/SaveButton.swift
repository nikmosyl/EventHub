//
//  SaveButton.swift
//  EventHub
//
//  Created by Николай Игнатов on 13.09.2025.
//

import SwiftUI

struct SaveButton: View {
    let onSaveTapped: () -> Void
    
    var body: some View {
        Button(action: onSaveTapped) {
            HStack(spacing: 12) {
                Image(systemName: "checkmark")
                    .font(.system(size: 18, weight: .medium))
                
                Text("Save")
                    .font(.system(size: 16, weight: .medium))
            }
            .foregroundColor(.buttonPrimary)
        }
    }
}

#Preview {
    SaveButton(
        onSaveTapped: { print("Save tapped") }
    )
    .padding()
}