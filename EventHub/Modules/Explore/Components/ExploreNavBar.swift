//
//  ExploreNavBar.swift
//  EventHub
//
//  Created by Drolllted on 12.09.2025.
//

import SwiftUI

struct ExploreNavBar: View {
    
    let categories: [CategoryModel]
    @Binding var selectedCategoryIds: Set<Int>
    @State private var showCurrentLocation: Bool = false
    let currentLocationName: String
    let currentLocationSlug: String
    let availableLocations: [Location]
    let isLoadingLocations: Bool
    let onLocationSelect: (String) -> Void
    
    //MARK: - for Pro Buttons
    let todayEvent: () -> Void
    let filmsEvent: () -> Void
    let listsEvent: () -> Void
    @Binding var showOnlyToday: Bool
    @Binding var showOnlyFilms: Bool
    
    var body: some View {
        VStack(spacing: 0){
            ZStack(alignment: .top) {
                Rectangle()
                    .fill(Color.navBarPrimary)
                    .frame(height: 200)
                    .clipShape(
                        RoundedRectangleShape(radius: 33, corners: [.bottomLeft, .bottomRight])
                    )
                    .ignoresSafeArea(.all)
                
                VStack(spacing: 20) {
                    CityLocationView(
                        showCurrentLocation: $showCurrentLocation,
                        currentLocation: currentLocationName
                    )
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .contextMenu {
                        if availableLocations.isEmpty {
                            Text("Загрузка городов...")
                        } else {
                            ForEach(availableLocations, id: \.slug) { location in
                                if let slug = location.slug, let name = location.name {
                                    Button {
                                        onLocationSelect(slug)
                                    } label: {
                                        Text(name)
                                    }
                                }
                            }
                        }
                    }
                    
                    NavigationLink {
                        // Экран поиска
                    } label: {
                        SearchButton()
                            .padding(.horizontal, 20)
                    }
                }
            }
            
            VStack(spacing: 20) {
                VariableSectionView(
                    categories: categories,
                    selectedCategoryIds: $selectedCategoryIds
                )
                
                ProButtons(
                    todayEvent: todayEvent,
                    filmsEvent: filmsEvent,
                    listsEvent: listsEvent,
                    showOnlyToday: $showOnlyToday,
                    showOnlyFilms: $showOnlyFilms
                )
            }
            .offset(y: -80)
        }
        .sheet(isPresented: $showCurrentLocation) {
            LocationSelectionView(
                locations: availableLocations,
                onSelect: { locationSlug in
                    onLocationSelect(locationSlug)
                    showCurrentLocation = false
                },
                currentLocationSlug: currentLocationSlug
            )
        }
    }
}
