//
//  MapView.swift
//  EventHub
//
//  Created by nikita on 21.09.2025.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    @State private var region: MKCoordinateRegion
    
    init() {
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6173),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }
    
    var body: some View {
        ZStack {
            Map(
                coordinateRegion: $region,
                showsUserLocation: true
            )
            .ignoresSafeArea()
            
            MapToolbar(searchText: $viewModel.searchText) {
                if let location = viewModel.lastLocation {
                    withAnimation {
                        region.center = location.coordinate
                    }
                }
            }
        }
        .task {
            await viewModel.loadPins(lat: 0, lon: 0, radious: 0)
        }
    }
}

#Preview {
    MapView()
}
