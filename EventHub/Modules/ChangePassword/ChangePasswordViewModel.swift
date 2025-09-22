//
//  ChangePasswordViewModel.swift
//  EventHub
//
//  Created by Drolllted on 22.09.2025.
//

import Foundation

final class ChangePasswordViewModel: ObservableObject {
    @Published var oldPassword = ""
    @Published var newPassword = ""
    @Published var repeatPassword = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    func changePasswordInProfile() async {
        guard !oldPassword.isEmpty, !newPassword.isEmpty, !repeatPassword.isEmpty else {
            errorMessage = "Please fill in all fields"
            return
        }
        
        guard newPassword == repeatPassword else {
            errorMessage = "New passwords don't match"
            return
        }
        
        guard newPassword.count >= 6 else {
            errorMessage = "New password must be at least 6 characters long"
            return
        }
        
        guard oldPassword != newPassword else {
            errorMessage = "New password must be different from the old one"
            return
        }
        
        isLoading = true
        errorMessage = nil
        successMessage = nil
        
        do {
            try await AuthService.shared.changePassword(
                oldPassword: oldPassword,
                newPassword: newPassword
            )
            
            successMessage = "Password changed successfully"
            
            await MainActor.run {
                oldPassword = ""
                newPassword = ""
                repeatPassword = ""
            }
            
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
            }
        }
        
        isLoading = false
    }
}
