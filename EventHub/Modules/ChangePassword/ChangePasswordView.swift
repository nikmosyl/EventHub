//
//  ChangePasswordView.swift
//  EventHub
//
//  Created by Drolllted on 22.09.2025.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = ChangePasswordViewModel()
    
    var body: some View {
        VStack(spacing: 50) {
            VStack(alignment: .leading, spacing: 60) {
                CustomTF(sfIcon: "lock", hint: "Old Password", isPassword: true, value: $viewModel.oldPassword)
                    .padding(.horizontal, 20)
                
                CustomTF(sfIcon: "lock", hint: "New Password", isPassword: true, value: $viewModel.newPassword)
                    .padding(.horizontal, 20)
                
                CustomTF(sfIcon: "lock", hint: "Repear New Password", isPassword: true, value: $viewModel.repeatPassword)
                    .padding(.horizontal, 20)
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.2)
                    .padding()
            } else {
                SignInButton(
                    backgroundColor: .buttonPrimary,
                    circleColor: .buttonSecondary,
                    title: "CHANGE\nPASSWORD"
                ) {
                    Task {
                        await viewModel.changePasswordInProfile()
                    }
                }
                .lineLimit(2)
                .frame(width: 300)
                .buttonStyle(PrimaryButtonStyle(height: 58, cornerRadius: 16))
                .background(.buttonPrimary, in: RoundedRectangle(cornerRadius: 16))
                .foregroundStyle(.white)
                .disabled(viewModel.oldPassword.isEmpty || viewModel.newPassword.isEmpty || viewModel.repeatPassword.isEmpty)
                .opacity((viewModel.oldPassword.isEmpty || viewModel.newPassword.isEmpty || viewModel.repeatPassword.isEmpty) ? 0.6 : 1.0)
            }
            Spacer()
        }
        .padding(.vertical, 60)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(Color.textDarkPrimary)
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Text("Change Password")
                    .font(.system(size: 24))
                    .fontWeight(.regular)
                    .foregroundStyle(.textDarkPrimary)
                    .minimumScaleFactor(0.7)
            }
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .alert("Success", isPresented: .constant(viewModel.successMessage != nil)) {
            Button("OK") {
                viewModel.successMessage = nil
                dismiss() // Закрываем экран после успешного изменения
            }
        } message: {
            Text(viewModel.successMessage ?? "")
        }
    }
}



#if DEBUG
#Preview{
    ChangePasswordView()
}
#endif
