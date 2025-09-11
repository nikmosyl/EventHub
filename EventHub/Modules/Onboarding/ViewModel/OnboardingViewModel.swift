//
//  Untitled.swift
//  EventHub
//
//  Created by Анастасия Тихонова on 11.09.2025.
//
import SwiftUI

@MainActor
class OnboardingViewModel: ObservableObject {
@Published var currentStepIndex: Int = 0
let steps: [OnboardingData] = OnboardingData.steps

 var onNext: (() -> Void)?
 var onSkip: (() -> Void)?

func nextStep() {
if currentStepIndex < steps.count - 1 {
currentStepIndex += 1
} else {
onNext?()
}
}
func skipOnboarding() { onSkip?() }
}
