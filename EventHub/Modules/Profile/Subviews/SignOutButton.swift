//
//  SignOutButton.swift
//  EventHub
//
//  Created by Николай Игнатов on 13.09.2025.
//

import SwiftUI

struct SignOutButton: View {
    let onSignOutTapped: () -> Void
    
    var body: some View {
        Button(action: onSignOutTapped) {
            HStack(spacing: 12) {
                Image(.signOut)
                    .font(.system(size: 18, weight: .medium))
                
                Text("Sign Out")
                    .font(.system(size: 16, weight: .medium))
            }
            .foregroundColor(.gray)
        }
    }
}

#Preview {
    SignOutButton(
        onSignOutTapped: { print("Sign Out tapped") }
    )
    .padding()
}