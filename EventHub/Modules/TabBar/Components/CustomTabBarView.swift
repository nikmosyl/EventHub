//
//  CustomTabBarView.swift
//  EventHub
//
//  Created by nikita on 09.09.2025.
//

import SwiftUI

struct CustomTabBarView: View {
    @ObservedObject var viewModel: TabBarViewModel
    
    private let barHeight: CGFloat = 100
    private let buttonSize: CGFloat = 64
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                HStack(spacing: 28) {
                    tabButton(.explore)
                    tabButton(.events)
                    
                    Button {
                        viewModel.selectedTab = .bookmark
                    } label: {
                        ZStack {
                            Circle()
                                .fill(
                                    viewModel.selectedTab == .bookmark
                                    ? Color.buttonCalored
                                    : Color.buttonPrimary
                                )
                                .frame(width: buttonSize, height: buttonSize)
                            
                            Image(systemName: "bookmark")
                                .resizable()
                                .foregroundStyle(.textLightPrimary)
                                .frame(width: 14, height: 17)
                        }
                    }
                    .shadow(color: .navBarPrimary.opacity(0.5), radius: 10, y: 8)
                    .offset(y: -barHeight/2)
                    
                    tabButton(.map)
                    tabButton(.profile)
                }
                .frame(height: barHeight)
                .frame(maxWidth: .infinity)
                .background(
                    Color
                        .background
                        .shadow(
                            color: .navBarPrimary.opacity(0.5),
                            radius: 8,
                            y: -3
                        )
                )
                
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private func tabButton(_ tab: TabItem) -> some View {
        Button {
            viewModel.selectedTab = tab
        } label: {
            if tab == .bookmark {
                
            } else {
                VStack {
                    Image(tab.icon)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                    
                    Text(tab.icon)
                        .font(.system(size: 12))
                }
                .foregroundColor(
                    tab == viewModel.selectedTab
                    ? .tabBarTextPrimary
                    : .tabBarTextSecondary
                )
            }
        }
    }
}

#Preview {
    TabBarView()
}
