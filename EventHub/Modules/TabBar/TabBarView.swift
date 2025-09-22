//
//  TabBarView.swift
//  EventHub
//
//  Created by nikita on 09.09.2025.
//

import SwiftUI

struct TabBarView: View {
    @StateObject private var viewModel = TabBarViewModel()
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $viewModel.selectedTab) {
                ExploreView()
                    .tabSafeAreaPadding()
                    .tag(TabItem.explore)
                EventsView()
                    .tabSafeAreaPadding()
                    .tag(TabItem.events)
                FavoritesView()
                    .tag(TabItem.bookmark)
                MapView()
                    .tabSafeAreaPadding()
                    .tag(TabItem.map)
                ProfileView()
                    .tabSafeAreaPadding()
                    .tag(TabItem.profile)
            }
            
            CustomTabBarView(viewModel: viewModel)
        }
    }
}

extension View {
    func tabSafeAreaPadding(_ padding: CGFloat = 50) -> some View {
        self.safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: padding)
        }
    }
}

#Preview {
    TabBarView()
}
