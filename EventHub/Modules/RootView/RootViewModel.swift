//
//  RootViewModel.swift
//  EventHub
//
//  Created by nikita on 13.09.2025.
//

import Foundation

@MainActor
final class RootViewModel: ObservableObject {
    @Published var isOnboardingComplete = DataManager.shared.isOnboardingComplete()
    @Published private(set) var isLoggedIn: Bool = false
    
    init() {
        checkAuthState()
    }
    
    func completeOnboarding() {
        DataManager.shared.completeOnboarding()
        isOnboardingComplete = true
    }
    
    func login() {
        isLoggedIn = true
    }
    
    func checkAuthState() {
        let user = AuthService.shared.currentUser
        let remember = UserDefaults.standard.bool(forKey: "rememberUser")
        
        if let user = user, remember {
            print("Восстановлен пользователь: \(user.uid)")
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
    }
    
    func logout() {
        do {
            try AuthService.shared.logout()
            UserDefaults.standard.removeObject(forKey: "rememberUser")
            isLoggedIn = false
        } catch {
            print("Ошибка выхода: \(error)")
        }
    }
}
