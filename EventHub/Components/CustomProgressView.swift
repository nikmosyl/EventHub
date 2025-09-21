//
//  CustomProgressView.swift
//  EventHub
//
//  Created by nikita on 22.09.2025.
//

import SwiftUI

struct CustomProgressView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .scaleEffect(1.5)
            .tint(Color.buttonPrimary)
    }
}

#Preview {
    CustomProgressView()
}
