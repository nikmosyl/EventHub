//
//  ResetPasswordView.swift
//  EventHub
//
//  Created by nikita on 22.09.2025.
//

import SwiftUI

struct ResetPasswordView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel = ResetPasswordViewModel()
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            VStack(spacing: 60) {
                Text("Please enter your email address to request a password reset")
                    .font(.system(size: 15))
                    .fontWeight(.regular)
                    .foregroundStyle(Color.textDarkPrimary)
                    .padding(.horizontal, 32)
                
                CustomTF(
                    value: $viewModel.email,
                    sfIcon: "envelope",
                    hint: "abc@email.com"
                )
                .padding(.horizontal, 32)
                
                SignInButton(
                    backgroundColor: .buttonPrimary,
                    circleColor: .buttonSecondary,
                    title: "SEND") {
                        viewModel.resetPassword()
                    }
                    .frame(width: 300)
                    .buttonStyle(PrimaryButtonStyle(height: 58, cornerRadius: 16))
                    .background(.buttonPrimary, in: RoundedRectangle(cornerRadius: 16))
                    .foregroundStyle(.white)
                
                if viewModel.isLoading {
                    CustomProgressView()
                }
                
                Spacer()
            }
            .padding(.top, 64)
        }
        .navigationBarBackButtonHidden()
        .background(Color.background.ignoresSafeArea())
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left")
                        .foregroundStyle(.textDarkPrimary)
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Text("Reset Passwor")
                    .font(.system(size: 24))
                    .fontWeight(.regular)
                    .foregroundStyle(.textDarkPrimary)
                    .minimumScaleFactor(0.7)
            }
        }
        .alert("result:", isPresented: $viewModel.showAlert) {
            Button("Okay", role: .cancel) {}
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

#Preview {
    ResetPasswordView()
}
