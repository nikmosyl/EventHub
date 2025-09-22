//
//  TabItem.swift
//  EventHub
//
//  Created by nikita on 09.09.2025.
//

import SwiftUI

enum TabItem: CaseIterable {
    case explore
    case events
    case bookmark
    case map
    case profile
    
    var icon: String {
        return switch self {
        case .explore: "Explore"
        case .events: "Events"
        case .bookmark: "bookmark"
        case .map: "Map"
        case .profile: "Profile"
        }
    }
}

// MARK: - Примеры экранов
struct EventsView: View {
    var body: some View {
        ZStack {
            Color
                .green
                .ignoresSafeArea()
            Text("EventsView")
        }
    }
}

#Preview {
    TabBarView()
}
