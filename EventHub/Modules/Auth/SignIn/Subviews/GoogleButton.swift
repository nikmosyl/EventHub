//
//  GoogleButton.swift
//  EventHub
//
//  Created by Mikhail Ustyantsev on 09.09.2025.
//

import SwiftUI

struct GoogleButton: View {
    let title: String
    let image: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 40) {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 26, height: 26)
                Text(title)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(.textDarkPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .foregroundStyle(.black) 
        }
    }
}
