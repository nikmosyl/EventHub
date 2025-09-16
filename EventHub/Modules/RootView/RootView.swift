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
        ZStack {
            if !viewModel.isOnboardingComplete {
                OnboardingView()
            } else if viewModel.isLoggedIn {
                TabBarView()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            } else {
                SignInView()
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.5), value: viewModel.isOnboardingComplete)
        .animation(.easeInOut(duration: 0.5), value: viewModel.isLoggedIn)
    }
}
