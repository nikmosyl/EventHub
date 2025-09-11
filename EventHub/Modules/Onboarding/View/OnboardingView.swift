//
//  OnboardingView.swift
//  EventHub
//
//  Created by Анастасия Тихонова on 11.09.2025.
//
import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    let onComplete: () -> Void

    var body: some View {
        GeometryReader { geometry in
        ZStack(alignment: .bottom) {
        Color.white.ignoresSafeArea()
        VStack(spacing: 0) {
        TabView(selection: $viewModel.currentStepIndex) {
        ForEach(viewModel.steps.indices, id: \.self) { idx in
        VStack(spacing: 0) {
        ZStack(alignment: .bottom) {
        Image(viewModel.steps[idx].imageName)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: geometry.size.width * 0.86, height: geometry.size.height * 0.57)
        .clipShape(RoundedRectangle(cornerRadius: 36, style: .continuous))
        LinearGradient(
        gradient: Gradient(colors: [Color.white.opacity(0.85),Color.white.opacity(0.0)]),startPoint: .bottom,endPoint: .top)
        .frame(height: 76)
        .clipShape(RoundedRectangle(cornerRadius: 36))
        }
        .padding(.top, 48)
        Spacer()
        }
        .tag(idx)
        }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .animation(.easeInOut, value: viewModel.currentStepIndex)
}

                // Нижняя синяя панель
                VStack(spacing: 24) {
                    Text(viewModel.steps[viewModel.currentStepIndex].title)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.textLightPrimary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    Text(viewModel.steps[viewModel.currentStepIndex].description)
                        .font(.system(size: 15))
                        .foregroundColor(.textLightSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    HStack {
                        Button("Skip") { viewModel.skipOnboarding() }
                            .foregroundColor(.textLightSecondary)
                            .font(.system(size: 18))
                        Spacer()
                        HStack(spacing: 8) {
                            ForEach(0..<viewModel.steps.count, id: \.self) { idx in
                                Circle()
                                    .fill(idx == viewModel.currentStepIndex ? Color.white : Color.textLightSecondary)
                                    .frame(width: 8, height: 8)
                            }
                        }
                        Spacer()
                        Button(viewModel.steps[viewModel.currentStepIndex].buttonText) {
                            viewModel.nextStep()
                        }
                        .foregroundColor(.textLightPrimary)
                        .fontWeight(.bold)
                        .font(.system(size: 18))
                    }
                    .padding(.leading, 40)
                    .padding(.trailing, 40)
                    .padding(.bottom, 37)
                }
               .frame(maxWidth: .infinity, minHeight: 288, maxHeight: 288)               .background(
                    Color("buttonPrimary")
//                       .clipShape(
//                            RoundedRectangleShape(
//                             radius: 48,
//                              corners: [.topLeft, .topRight] // только верхние углы
                            )
//                      )
//              )
                .ignoresSafeArea(edges: .bottom)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .onAppear {
            viewModel.onNext = onComplete
            viewModel.onSkip = onComplete
        }
    }
}


#Preview {
    ContentView()
}
