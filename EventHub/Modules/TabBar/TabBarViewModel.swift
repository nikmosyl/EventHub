//
//  TabBarViewModel.swift
//  EventHub
//
//  Created by nikita on 09.09.2025.
//

import Foundation

final class TabBarViewModel: ObservableObject {
    @Published var selectedTab: TabItem = .explore
    @Published var showAddView: Bool = false
    
    func select(tab: TabItem) {
        selectedTab = tab
    }
}
