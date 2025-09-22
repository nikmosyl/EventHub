//
//  CustomTF.swift
//  EventHub
//
//  Created by Mikhail Ustyantsev on 09.09.2025.
//

import SwiftUI

struct CustomTF: View {
    @State private var showPassword: Bool = false
    @Binding var value: String
    var sfIcon: String
    var iconTint: Color = .gray
    var hint: String
    var isPassword: Bool = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(sfIcon)
                .foregroundStyle(iconTint)
                .frame(width: 30)
                .offset(y: 2)
            ZStack {
                SecureField(
                    "",
                    text: $value,
                    prompt: Text(hint).foregroundColor(Color.textDarkSecondary)
                )
                .opacity(isPassword && !showPassword ? 1 : 0)
                
                TextField(
                    "",
                    text: $value,
                    prompt: Text(hint).foregroundColor(Color.textDarkSecondary)
                )
                .opacity(!isPassword || showPassword ? 1 : 0)
            }
            .overlay(alignment: .trailing) {
                if isPassword {
                    Button(action: {
                        withAnimation {
                            showPassword.toggle()
                        }
                    }) {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundStyle(.textLightSecondary)
                            .padding(10)
                            .frame(width: 30)
                            .contentShape(.rect)
                    }
                }
            }
                     
        }
        .padding(.horizontal, 10)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.borderPrimary, lineWidth: 1)
                .frame(height: 60)
        }
    }
}

