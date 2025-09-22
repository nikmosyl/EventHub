//
//  SignInView.swift
//  EventHub
//
//  Created by Mikhail Ustyantsev on 08.09.2025.
//

import SwiftUI

struct SignInView: View {
    @FocusState private var keyboardIsActive: Bool
    
    @State private var emailID: String = ""
    @State private var password: String = ""
    @State private var rememberUser = true
    
    @State private var showSignUp: Bool = false
    
    @State var isLoading = false
    
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 40) {
                if !keyboardIsActive {
                    HStack {
                        EventHubLogoView()
                        Spacer()
                    }
                    .padding(.horizontal, 40)
                }
                
                VStack(alignment: .center, spacing: 50) {
                    HStack {
                        Text("Sign In")
                            .font(.system(size: 24, weight: .medium))
                        Spacer()
                    }
                    
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
                    
                    HStack {
                        Toggle(isOn: $rememberUser) { }
                            .tint(.buttonPrimary)
                            .labelsHidden()
                        
                        Text("Remember Me")
                            .font(.system(size: 14))
                            .fontWeight(.regular)
                            .foregroundStyle(.textDarkPrimary)
                        
                        Spacer()
                        
                        NavigationLink {
                            ResetPasswordView()
                        } label: {
                            Text("Forgot Password?")
                                .font(.system(size: 14))
                                .fontWeight(.regular)
                                .foregroundStyle(.textDarkPrimary)
                        }
                        
                    }
                    
                    VStack(alignment: .center, spacing: 40) {
                        
                        ZStack {
                            SignInButton(
                                backgroundColor: .buttonPrimary,
                                circleColor: .buttonSecondary,
                                title: "SIGN IN") {
                                    //sign in action
                                    handleAuthButton()
                                }
                                .frame(width: 300)
                                .buttonStyle(PrimaryButtonStyle(height: 58, cornerRadius: 16))
                                .background(.buttonPrimary, in: RoundedRectangle(cornerRadius: 16))
                                .foregroundStyle(.white)
                            
                            if isLoading {
                                HStack {
                                    CustomProgressView()
                                    
                                    Spacer()
                                }
                            }
                        }
                        if !keyboardIsActive {
                            Text("OR")
                                .foregroundStyle(.secondary)
                            
                            ZStack {
                                GoogleButton(
                                    title: "Login with Google",
                                    image: "googleIcon",
                                    action: {
                                        Task {
                                            await handleGoogleSignInButton()
                                        }
                                    }
                                )
                                .frame(width: 300)
                                .buttonStyle(PrimaryButtonStyle(height: 58, cornerRadius: 16))
                                .background(Color.background, in: RoundedRectangle(cornerRadius: 16))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                                )
                                .foregroundStyle(.black)
                                
                                if isLoading {
                                    HStack {
                                        CustomProgressView()
                                        
                                        Spacer()
                                    }
                                }
                            }
                        }
                        
                        HStack {
                            Text("Don't have an account?")
                            
                            NavigationLink {
                                SignUpView()
                            } label: {
                                Text("Sign Up")
                                    .foregroundColor(Color.buttonPrimary)
                            }
                        }
                    }
                }
                .padding(.horizontal, 25)
                
                Spacer()
            }
        }
        .alert("Error:", isPresented: $showError) {
            Button("Okay", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
        .focused($keyboardIsActive)
    }
    
    
    private func handleGoogleSignInButton() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await DataManager.shared.loginUserWithGoogle(
                rememberUser: rememberUser
            )
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
    
    private func handleAuthButton() {
        isLoading = true
        defer { isLoading = false }
        
        Task {
            do {
                try await DataManager.shared.loginUser(
                    email: emailID,
                    password: password,
                    rememberUser: rememberUser
                )
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }
}

#Preview {
    SignInView()
}
