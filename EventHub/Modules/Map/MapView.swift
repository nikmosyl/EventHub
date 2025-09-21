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
                showsUserLocation: true,
                annotationItems: viewModel.pins
            ) { pin in
                MapAnnotation(
                    coordinate: CLLocationCoordinate2D(latitude: pin.lat, longitude: pin.lon)
                ) {
                    MapPin(icon: pin.icon, color: pin.color)
                        .onTapGesture {
                            Task {
                                await viewModel.loadEvent(id: pin.id)
                            }
                        }
                }
            }
            .ignoresSafeArea()
            .onChange(of: EquatableRegion(region: region)) { newWrapped in
                let newRegion = newWrapped.region
                viewModel.updateRegion(
                    lat: newRegion.center.latitude,
                    lon: newRegion.center.longitude,
                    radius: Int(newRegion.radiusInMeters)
                )
            }
            
            MapToolbar(searchText: $viewModel.searchText) {
                if let location = viewModel.lastLocation {
                    withAnimation {
                        region.center = location.coordinate
                    }
                }
            }
            
            if viewModel.isLoading {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        CustomProgressView()
                            .padding(.horizontal, 24)
                    }
                }
            }
            
            if let event = viewModel.currentEvent {
                VStack {
                    Spacer()
                    
                    EventCellView(event: event)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 10)
                }
            }
        }
    }
}

#Preview {
    MapView()
}
