//
//  RootView.swift
//  EventHub
//
//  Created by nikita on 13.09.2025.
//

import SwiftUI

struct RootView: View {
    @StateObject private var viewModel: RootViewModel
    
    init() {
        let rootViewModel = RootViewModel()
        _viewModel = StateObject(wrappedValue: rootViewModel)
        DataManager.shared.setRootViewModel(rootViewModel)
    }
    
    var body: some View {
        if !viewModel.isOnboardingComplete {
            OnboardingView()
        } else if viewModel.isLoggedIn {
            TabBarView()
        } else {
            SignInView()
        }
    }
}
