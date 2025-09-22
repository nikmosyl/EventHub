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
    @Published var isLoggedIn: Bool = false
    
    init() {
        checkAuthState()
    }
    
    func completeOnboarding() {
        isOnboardingComplete = true
    }
    
    func login() {
        print("Залогинились на RootViewModel")
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
        print("isLoggedIn:", isLoggedIn)
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
