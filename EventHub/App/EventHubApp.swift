//
//  EventHubApp.swift
//  EventHub
//
//  Created by nikita on 07.09.2025.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct EventHubApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var finishedOnboarding: Bool = UserDefaults.standard.bool(forKey: "finishedOnboarding")

    var body: some Scene {
        WindowGroup {
            if finishedOnboarding {
                NavigationView {
                    TabBarView()
                }
            } else {
                OnboardingView {
                    UserDefaults.standard.set(true, forKey: "finishedOnboarding")
                    finishedOnboarding = true
                }
            }
        }
    }
}
