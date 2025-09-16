//
//  OnboardingView.swift
//  EventHub
//
//  Created by Анастасия Тихонова on 14.09.2025.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            VStack {
                TabView(selection: $viewModel.currentStepIndex) {
                    ForEach(viewModel.steps.indices, id: \.self) { index in
                        OnboardingImage(imageName: viewModel.steps[index].imageName)
                            .tag(index)
                    }
                }
                .tabViewStyle(
                    PageTabViewStyle(indexDisplayMode: .never)
                )
            }
            
            VStack {
                Spacer()
                OnboardingPanel(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    OnboardingView()
}
