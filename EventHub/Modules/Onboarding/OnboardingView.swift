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
            
            VStack(spacing: 0){
                
                TabView(selection: $viewModel.currentStepIndex) {
                    ForEach(viewModel.steps.indices, id: \.self) { index in
                        OnboardingImage(imageName: viewModel.steps[index].imageName)
                            .tag(index)
                    }
                }
                .tabViewStyle(
                                    PageTabViewStyle(indexDisplayMode: .never)
                                )
                                
                                Spacer()
                            }
                            
                            VStack {
                                Spacer()
                                OnboardingPanel(viewModel: viewModel)
                            }
                        }
                    }
                }

private struct OnboardingImage: View {
    let imageName: String
    var body: some View {
        ZStack(alignment: .top) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 270, height: 538.5)
                
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.background.opacity(0.00),
                    Color.background.opacity(0.30),
                    Color.background.opacity(0.99)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        }
        .padding(.top, 20)
        .background(.textLightPrimary)
    }
}

private struct OnboardingPanel: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 16) {
                Text(viewModel.currentStep.title)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.textLightPrimary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .padding(.horizontal, 24)
                
                Text(viewModel.currentStep.description)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.textLightSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .frame(width: 295, height: 50, alignment: .center)
                    .padding(.top, 16)
            }
            .padding(.top, 40)
            
            Spacer()
            
            HStack {
                            Button("Skip") {
                                viewModel.skipOnboarding()
                            }
                            .foregroundColor(.textLightSecondary)
                            .font(.system(size: 18))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer()
                            
                            HStack(spacing: 8) {
                                ForEach(viewModel.steps.indices, id: \.self) { idx in
                                    Circle()
                                        .fill(idx == viewModel.currentStepIndex ? Color.textLightPrimary : Color.textLightSecondary)
                                        .frame(width: 8, height: 8, alignment: .center)
                                }
                            }
                            
                            Spacer()
                            
                            Button(viewModel.currentStep.buttonText) {
                                viewModel.nextStep()
                            }
                            .foregroundColor(.textLightPrimary)
                            .font(.system(size: 18, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 37)
                    }
                    .frame(maxWidth: .infinity, minHeight: 260, maxHeight: 288)
                    .background(
                        Color.buttonPrimary
                            .clipShape(
                                RoundedRectangleShape(
                                    radius: 48,
                                    corners: [.topLeft, .topRight]
                                )
                            )
                            .ignoresSafeArea(
                                edges: .bottom
                            )
                                    )
                                }
                            }

#Preview {
    OnboardingView()
}
