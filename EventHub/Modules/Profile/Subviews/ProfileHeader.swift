//
//  ProfileHeader.swift
//  EventHub
//
//  Created by Николай Игнатов on 13.09.2025.
//

import SwiftUI

struct ProfileHeader: View {
    let avatarImage: UIImage?
    let name: String
    let isEditingMode: Bool
    let onEditProfileTapped: () -> Void
    let onEditAvatarTapped: () -> Void
    let onEditNameTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                if let avatarImage = avatarImage {
                    Image(uiImage: avatarImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 96, height: 96)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                        )
                        .frame(width: 96, height: 96)
                }
                
                if isEditingMode {
                    Button(action: onEditAvatarTapped) {
                        Image(.edit)
                    }
                    .offset(x: 45, y: -45)
                }
            }
            
            VStack(spacing: 16) {
                HStack {
                    Text(name)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.primary)
                    
                    if isEditingMode {
                        Button(action: onEditNameTapped) {
                            Image(.edit)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.buttonPrimary)
                        }
                    }
                }
                
                if !isEditingMode {
                    Button(action: onEditProfileTapped) {
                        HStack(spacing: 8) {
                            Image(.edit)
                                .font(.system(size: 16, weight: .medium))
                            Text("Edit Profile")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .foregroundColor(.buttonPrimary)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.buttonPrimary, lineWidth: 1.5)
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileHeader(
        avatarImage: nil,
        name: "Ashfak Sayem",
        isEditingMode: false,
        onEditProfileTapped: { print("Edit Profile tapped") },
        onEditAvatarTapped: { print("Edit Avatar tapped") },
        onEditNameTapped: { print("Edit Name tapped") }
    )
    .padding()
}
