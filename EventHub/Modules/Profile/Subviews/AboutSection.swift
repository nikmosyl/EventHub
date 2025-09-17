//
//  AboutSection.swift
//  EventHub
//
//  Created by Николай Игнатов on 13.09.2025.
//

import SwiftUI

struct AboutSection: View {
    let aboutText: String
    let isEditingMode: Bool
    let onEditAboutTapped: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("About Me")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.primary)

                if isEditingMode {
                    Button(action: onEditAboutTapped) {
                        Image(.edit)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.buttonPrimary)
                    }
                }

                Spacer()
            }

            ScrollView {
                Text(aboutText)
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        AboutSection(
            aboutText: "Enjoy your favorite dishe and a lovely your friends and family and have a great time. Food from local food trucks will be available for purchase.",
            isEditingMode: false,
            onEditAboutTapped: { print("Edit About tapped") }
        )

        AboutSection(
            aboutText: "Enjoy your favorite dishe and a lovely your friends and family and have a great time. Food from local food trucks will be available for purchase.",
            isEditingMode: true,
            onEditAboutTapped: { print("Edit About tapped") }
        )
    }
    .padding()
}
