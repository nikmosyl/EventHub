//
//  ResetPasswordViewModel.swift
//  EventHub
//
//  Created by nikita on 22.09.2025.
//

import Foundation

@MainActor
final class ResetPasswordViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    @Published var isLoading = false
    
    func resetPassword() {
        isLoading = true
        defer { isLoading = false }
        
        Task {
            do {
                try await DataManager.shared.resetUserPassword(email: email)
                alertMessage = "Done"
                showAlert = true
            } catch {
                alertMessage = error.localizedDescription
                showAlert = true
            }
        }
    }
}
