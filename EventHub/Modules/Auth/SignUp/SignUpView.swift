//
//  SignUpView.swift
//  EventHub
//
//  Created by Mikhail Ustyantsev on 10.09.2025.
//

import SwiftUI

struct SignUpView: View {
    @State private var fullName: String = ""
    @State private var emailID: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    @State private var isSigningByEmail: Bool = false
    @State private var isSigningByGoogle: Bool = false
    @State private var alertMessage: String?
    
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("background")
                    .ignoresSafeArea()
                
                VStack(alignment: .center, spacing: 50) {
                    /// Custom Text Fields
                    CustomTF(sfIcon: "person", hint: "Full name", value: $fullName)
                    
                    CustomTF(sfIcon: "envelope", hint: "abc@email.com", value: $emailID)
                    
                    CustomTF(sfIcon: "lock", hint: "Your password", isPassword: true, value: $password)
                        .textContentType(.none)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                    
                    CustomTF(sfIcon: "lock", hint: "Confirm password", isPassword: true, value: $confirmPassword)
                        .textContentType(.none)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                    
                    VStack(alignment: .center, spacing: 40) {
                        SignInButton(
                            backgroundColor: .buttonPrimary,
                            circleColor: .buttonSecondary,
                            title: isSigningByEmail ? "PLEASE WAIT…" : "SIGN UP") {
                                //handle sign up action
                                handleEmailSignUp()
                            }
                            .disabled(isSigningByEmail)
                            .frame(width: 300)
                            .buttonStyle(PrimaryButtonStyle(height: 58, cornerRadius: 16))
                            .background(.buttonPrimary, in: RoundedRectangle(cornerRadius: 16))
                            .foregroundStyle(.white)
                        
                        Text("OR")
                            .foregroundStyle(.secondary)
                        
                        GoogleButton(
                            title: isSigningByGoogle ? "Signing in…" : "Login with Google",
                            image: "googleIcon",
                            action: {
                                //Login with Google Auth Service
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
                            isPresented = false
                        }) {
                            Text("Sign in")
                                .foregroundColor(Color.buttonPrimary)
                        }
                    }
                }
                .padding(.horizontal, 25)
                
            }
            .navigationTitle("Sign up")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .alert("Oops", isPresented: Binding(
                get: { alertMessage != nil },
                set: { _ in alertMessage = nil }
            )) {
                Button("OK", role: .cancel) { alertMessage = nil }
            } message: {
                Text(alertMessage ?? "")
            }
        }
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
            } catch {
                isSigningByEmail = false
                alertMessage = error.localizedDescription
            }
        }
    }
    
    private func handleGoogleSignIn() {
        #warning("TO DO: поднять какой-то флаг, чтобы отслеживать пока процесс идёт и крутить ромашку")
        Task {
            do {
                try await DataManager.shared.loginUserWithGoogle(
                    rememberUser: true
                )
            } catch {
                print("Ошибка в SignIn.handleGoogleSignInButton: ", error)
            }
        }
        #warning("TO DO: снять флаг")
    }
    
    // MARK: - Utils
    private func isValidEmail(_ email: String) -> Bool {
        let pattern = #"^\S+@\S+\.\S+$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }
}

#Preview {
    SignUpView(isPresented: .constant(true))
}
