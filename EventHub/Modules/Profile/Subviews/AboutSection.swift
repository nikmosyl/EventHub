//
//  AboutSection.swift
//  EventHub
//
//  Created by Николай Игнатов on 13.09.2025.
//

import SwiftUI

struct AboutSection: View {
    let aboutText: String
    let isShowingFullText: Bool
    let isEditingMode: Bool
    let onReadMoreTapped: () -> Void
    let onEditAboutTapped: () -> Void
    
    private let maxLinesPreview = 4
    @State private var isTruncated = false
    
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
            
            if isShowingFullText {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(aboutText)
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxHeight: 200)
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Text(aboutText)
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                        .lineLimit(maxLinesPreview)
                        .background(
                            ViewThatFits(in: .vertical) {
                                Text(aboutText)
                                    .font(.system(size: 16))
                                    .hidden()
                                    .onAppear {
                                        isTruncated = false
                                    }
                                
                                Color.clear
                                    .onAppear {
                                        isTruncated = true
                                    }
                            }
                        )
                    
                    if isTruncated {
                        Button(action: onReadMoreTapped) {
                            Text("Read More")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.buttonPrimary)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        AboutSection(
            aboutText: "Enjoy your favorite dishe and a lovely your friends and family and have a great time. Food from local food trucks will be available for purchase.",
            isShowingFullText: false,
            isEditingMode: false,
            onReadMoreTapped: { print("Read More tapped") },
            onEditAboutTapped: { print("Edit About tapped") }
        )
        
        AboutSection(
            aboutText: "Enjoy your favorite dishe and a lovely your friends and family and have a great time. Food from local food trucks will be available for purchase.",
            isShowingFullText: true,
            isEditingMode: true,
            onReadMoreTapped: { print("Read More tapped") },
            onEditAboutTapped: { print("Edit About tapped") }
        )
    }
    .padding()
}
