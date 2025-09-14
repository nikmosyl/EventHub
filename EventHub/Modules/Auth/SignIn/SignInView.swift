//
//  SignInView.swift
//  EventHub
//
//  Created by Mikhail Ustyantsev on 08.09.2025.
//

import SwiftUI

struct SignInView: View {
    @StateObject var rootViewModel: RootViewModel
    
    @State private var emailID: String = ""
    @State private var password: String = ""
    @State private var rememberUser = true
    
    @State private var showSignUp: Bool = false
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color("background")
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 40) {
                    HStack {
                        EventHubLogoView()
                        Spacer()
                    }
                    .padding(.horizontal, 40)
                    
                    VStack(alignment: .center, spacing: 50) {
                        HStack {
                            Text("Sign In")
                                .font(.system(size: 24, weight: .medium))
                            Spacer()
                        }
                        
                        /// Custom Text Fields
                        CustomTF(sfIcon: "envelope", hint: "abc@email.com", value: $emailID)
                        
                        CustomTF(sfIcon: "lock", hint: "Your password", isPassword: true, value: $password)
                        
                        HStack {
                            Toggle(isOn: $rememberUser) { }
                                .tint(.buttonPrimary)
                                .labelsHidden()
                            Spacer()
                            Text("Remember Me")
                            Spacer()
                            Button("Forgot Password?") {
                                //TO DO navigation to reset password
                            }
                            .tint(.primary)
                        }
                        
                        VStack(alignment: .center, spacing: 40) {
                            
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
                            
                            Text("OR")
                                .foregroundStyle(.secondary)
                            
                            GoogleButton(
                                title: "Login with Google",
                                image: "googleIcon",
                                action: {
                                    //Login with Google Auth Service
                                    handleGoogleSignInButton()
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
                        }
                        
                        HStack {
                            Text("Don't have an account?")
                            
                            Button(action: {
                                showSignUp = true
                            }) {
                                Text("Sign Up")
                                    .foregroundColor(Color.buttonPrimary)
                            }
                        }
                    }
                    .padding(.horizontal, 25)
                    
                    Spacer()
                }
            }
            .navigationDestination(
                isPresented: $showSignUp) {
                    SignUpView(rootViewModel: rootViewModel, isPresented: $showSignUp)
                }
        }
    }
    
    
    private func handleGoogleSignInButton() {
        #warning("TO DO: поднять какой-то флаг, чтобы отслеживать пока процесс идёт и крутить ромашку")
        Task {
            do {
                try await DataManager.shared.loginUserWithGoogle(
                    rememberUser: rememberUser
                )
            } catch {
                print("Ошибка в SignIn.handleGoogleSignInButton: ", error)
            }
        }
        #warning("TO DO: снять флаг")
    }
    
    private func handleAuthButton() {
        #warning("TO DO: поднять какой-то флаг, чтобы отслеживать пока процесс идёт и крутить ромашку")
        Task {
            do {
                try await DataManager.shared.loginUser(
                    email: emailID,
                    password: password,
                    rememberUser: rememberUser
                )
            } catch {
                print("Ошибка в SignIn.handleGoogleSignInButton: ", error)
            }
        }
        #warning("TO DO: снять флаг")
    }
}

#Preview {
    SignInView(rootViewModel: RootViewModel())
}
