//
//  SignUpView.swift
//  EventHub
//
//  Created by Mikhail Ustyantsev on 10.09.2025.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    @FocusState private var keyboardIsActive: Bool
    
    @State private var fullName: String = ""
    @State private var emailID: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    @State private var isSigningByEmail: Bool = false
    @State private var isSigningByGoogle: Bool = false
    @State private var alertMessage: String?
    
    //@Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 50) {
                CustomTF(
                    value: $fullName,
                    sfIcon: "person",
                    hint: "Full name"
                )
                
                CustomTF(
                    value: $emailID,
                    sfIcon: "envelope",
                    hint: "abc@email.com"
                )
                
                CustomTF(
                    value: $password,
                    sfIcon: "lock",
                    hint: "Your password",
                    isPassword: true
                )
                
                CustomTF(
                    value: $confirmPassword,
                    sfIcon: "lock",
                    hint: "Confirm password",
                    isPassword: true
                )
                
                VStack(alignment: .center, spacing: 40) {
                    SignInButton(
                        backgroundColor: .buttonPrimary,
                        circleColor: .buttonSecondary,
                        title: isSigningByEmail ? "PLEASE WAIT…" : "SIGN UP") {
                            handleEmailSignUp()
                        }
                        .disabled(isSigningByEmail)
                        .frame(width: 300)
                        .buttonStyle(PrimaryButtonStyle(height: 58, cornerRadius: 16))
                        .background(.buttonPrimary, in: RoundedRectangle(cornerRadius: 16))
                        .foregroundStyle(.white)
                    
                    if !keyboardIsActive {
                        Text("OR")
                            .foregroundStyle(.secondary)
                        
                        GoogleButton(
                            title: isSigningByGoogle ? "Signing in…" : "Login with Google",
                            image: "googleIcon",
                            action: {
                                handleGoogleSignIn()
                            }
                        )
                        .disabled(isSigningByGoogle)
                        .frame(width: 300)
                        .buttonStyle(PrimaryButtonStyle(height: 58, cornerRadius: 16))
                        .background(Color.background, in: RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                        )
                        .foregroundStyle(.black)
                    }
                    
                    HStack {
                        Text("Already have an account?")
                        
                        Button(action: {
                            //handle sign in action
                            dismiss()
                        }) {
                            Text("Sign in")
                                .foregroundColor(Color.buttonPrimary)
                        }
                    }
                }
            }
            .padding(.horizontal, 25)
            
        }
        .navigationTitle("Sign up")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .alert("Message:", isPresented: Binding(
            get: { alertMessage != nil },
            set: { _ in alertMessage = nil }
        )) {
            Button("OK", role: .cancel) { alertMessage = nil }
        } message: {
            Text(alertMessage ?? "")
        }
        .focused($keyboardIsActive)
    }
    
    // MARK: - Actions
    
    private func handleEmailSignUp() {
        
        guard !fullName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "Please enter your full name."
            return
        }
        guard isValidEmail(emailID) else {
            alertMessage = "Please enter a valid email."
            return
        }
        guard password.count >= 6 else {
            alertMessage = "Password must be at least 6 characters."
            return
        }
        guard password == confirmPassword else {
            alertMessage = "Passwords do not match."
            return
        }
        
        isSigningByEmail = true
        Task {
            do {
                try await DataManager.shared.registerUser(
                    email: emailID,
                    password: password,
                    fullName: fullName
                )
                alertMessage = "Complete"
                
                dismiss()
            } catch {
                isSigningByEmail = false
                alertMessage = error.localizedDescription
            }
        }
    }
    
    private func handleGoogleSignIn() {
        Task {
            do {
                try await DataManager.shared.loginUserWithGoogle(
                    rememberUser: true
                )
            } catch {
                print("Ошибка в SignIn.handleGoogleSignInButton: ", error)
            }
        }
    }
    
    // MARK: - Utils
    private func isValidEmail(_ email: String) -> Bool {
        let pattern = #"^\S+@\S+\.\S+$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }
}

#Preview {
    SignUpView()
}
