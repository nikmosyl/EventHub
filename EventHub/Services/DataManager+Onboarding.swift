//
//  DataManager+Onboarding.swift
//  EventHub
//
//  Created by nikita on 13.09.2025.
//

import Foundation

enum UserSettingsLink: String {
    case onboarding
}

extension DataManager {
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: UserSettingsLink.onboarding.rawValue)
    }
    
    func isOnboardingComplete() -> Bool {
        UserDefaults.standard.bool(forKey: UserSettingsLink.onboarding.rawValue)
    }
}
