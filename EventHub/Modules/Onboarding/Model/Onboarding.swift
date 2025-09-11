//
//  Onboarding.swift
//  EventHub
//
//  Created by Анастасия Тихонова on 11.09.2025.
//
import SwiftUI

struct OnboardingData: Identifiable, Hashable {
    let id: Int
    let title: String
    let description: String
    let buttonText: String
    let imageName: String
    let isLastStep: Bool
}

extension OnboardingData {
    static let steps: [OnboardingData] = [
        OnboardingData(id: 0, title: "Explore Upcoming and Nearby Events", description: "In publishing and graphic design, Lorem is a placeholder text commonly", buttonText: "Next", imageName: "onboarding1", isLastStep: false),
        OnboardingData(id: 1, title: "Web Have Modern Events Calendar Feature", description: "In publishing and graphic design, Lorem is a placeholder text commonly", buttonText: "Next", imageName: "onboarding2", isLastStep: false),
        OnboardingData(id: 2, title: "To Look Up More Events or Activities Nearby By Map", description: "In publishing and graphic design, Lorem is a placeholder text commonly", buttonText: "Get Started", imageName: "onboarding3", isLastStep: true)
    ]
}



