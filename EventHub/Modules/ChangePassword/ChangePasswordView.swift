//
//  ChangePasswordView.swift
//  EventHub
//
//  Created by Drolllted on 22.09.2025.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(Color.textDarkPrimary)
                }

            }
        }
    }
    
}

#if DEBUG
#Preview{
    ChangePasswordView()
}
#endif
