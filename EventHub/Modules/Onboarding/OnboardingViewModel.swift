//
//  OnboardingViewModel.swift
//  EventHub
//
//  Created by Анастасия Тихонова on 14.09.2025.
//

import SwiftUI

final class OnboardingViewModel: ObservableObject {
    @Published var currentStepIndex: Int = 0
    let steps: [OnboardingData] = OnboardingData.steps
    
    var currentStep: OnboardingData {
        steps[currentStepIndex]
    }
    
    @MainActor
    func nextStep() {
        if currentStepIndex < steps.count - 1 {
            currentStepIndex += 1
        } else {
            DataManager.shared.completeOnboarding()
        }
    }
    
    @MainActor
    func skipOnboarding() {
        DataManager.shared.completeOnboarding()
    }
}
