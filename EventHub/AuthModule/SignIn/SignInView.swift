//
//  SignInView.swift
//  EventHub
//
//  Created by Mikhail Ustyantsev on 08.09.2025.
//

import SwiftUI

struct SignInView: View {
    /// View Properties
    @State private var emailID: String = ""
    @State private var password: String = ""
    
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
                    
                    VStack(alignment: .leading, spacing: 50) {
                        Text("Sign In")
                            .font(.system(size: 24, weight: .medium))
                        
                        /// Custom Text Fields
                        CustomTF(sfIcon: "envelope", hint: "abc@email.com", value: $emailID)
                        
                        CustomTF(sfIcon: "lock", hint: "Your password", isPassword: true, value: $password)
                    }
                    .padding(.horizontal, 25)
                    
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    SignInView()
}
