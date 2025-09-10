//
//  SignUpView.swift
//  EventHub
//
//  Created by Mikhail Ustyantsev on 10.09.2025.
//

import SwiftUI

struct SignUpView: View {
    
    /// View Properties
    @State private var fullName: String = ""
    @State private var emailID: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    ///Navigation
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
                    
                    CustomTF(sfIcon: "lock", hint: "Confirm password", isPassword: true, value: $confirmPassword)
                    
                    VStack(alignment: .center, spacing: 40) {
                        SignInButton(
                            backgroundColor: .buttonPrimary,
                            circleColor: .buttonSecondary,
                            title: "SIGN UP") {
                                //handle sign up action
                                
                            }
                            .frame(width: 300)
                            .buttonStyle(PrimaryButtonStyle(height: 58, cornerRadius: 16))
                                .filledButtonBackground(.buttonPrimary)
                                .foregroundStyle(.white)
                        
                        Text("OR")
                            .foregroundStyle(.secondary)
                        
                        GoogleButton(
                            title: "Login with Google",
                            image: "googleIcon",
                            action: {
                                //Login with Google Auth Service
                                
                            }
                        )
                            .frame(width: 300)
                            .buttonStyle(PrimaryButtonStyle(height: 58, cornerRadius: 16))
                            .filledButtonBackground(Color.white)
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
        }
    }
    
}

#Preview {
    SignUpView(isPresented: .constant(true))
}
