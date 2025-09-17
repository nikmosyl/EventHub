//
//  TabBarView.swift
//  EventHub
//
//  Created by nikita on 09.09.2025.
//

import SwiftUI

struct TabBarView: View {
    @StateObject private var viewModel = TabBarViewModel()
    
    let padding: CGFloat = 50
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                TabView(selection: $viewModel.selectedTab) {
                    ExploreView()
                        .tabSafeAreaPadding(padding)
                        .tag(TabItem.explore)
                    EventsView()
                        .tabSafeAreaPadding(padding)
                        .tag(TabItem.events)
                    BookmarkView()
                        .tabSafeAreaPadding(padding)
                        .tag(TabItem.bookmark)
                    TestView()
                        .tabSafeAreaPadding(padding)
                        .tag(TabItem.map)
                    ProfileView()
                        .tabSafeAreaPadding(padding)
                        .tag(TabItem.profile)
                }
                
                CustomTabBarView(viewModel: viewModel)
            }
        }
    }
}

extension View {
    func tabSafeAreaPadding(_ padding: CGFloat) -> some View {
        self.safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: padding)
        }
    }
}

#Preview {
    TabBarView()
}
