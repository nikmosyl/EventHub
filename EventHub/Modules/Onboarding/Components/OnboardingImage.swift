//
//  OnboardingImage.swift
//  EventHub
//
//  Created by nikita on 16.09.2025.
//

import SwiftUI

struct OnboardingImage: View {
    let imageName: String
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 270, height: 538.5)
                .overlay {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.background.opacity(1),
                            Color.background.opacity(0.9),
                            Color.background.opacity(0.2),
                            Color.background.opacity(0),
                        ]),
                        startPoint: .bottom,
                        endPoint: .center
                    )
                }
                .padding(.top, 40)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingImage(imageName: "onboarding1")
}
