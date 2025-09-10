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
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .explore:
            ExploreView()
        case .events:
            EventsView()
        case .bookmark:
            BookmarkView()
        case .map:
            MapView()
        case .profile:
            ProfileView()
        }
    }
}

// MARK: - Примеры экранов
struct ExploreView: View {
    var body: some View {
        ZStack {
            Color
                .red
                .ignoresSafeArea()
            Text("ExploreView")
        }
    }
}

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

struct BookmarkView: View {
    var body: some View {
        ZStack {
            Color
                .blue
                .ignoresSafeArea()
            Text("BookmarkView")
        }
    }
}

struct MapView: View {
    var body: some View {
        ZStack {
            Color
                .cyan
                .ignoresSafeArea()
            Text("MapView")
        }
    }
}

struct ProfileView: View {
    var body: some View {
        ZStack {
            Color
                .yellow
                .ignoresSafeArea()
            Text("ProfileView")
        }
    }
}
