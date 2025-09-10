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
        NavigationStack {
            ZStack(alignment: .bottom) {
                viewModel.selectedTab.view
                
                CustomTabBarView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    TabBarView()
}
