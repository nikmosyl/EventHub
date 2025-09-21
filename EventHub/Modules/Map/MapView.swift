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
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        if let location = viewModel.lastLocation {
                            withAnimation {
                                viewModel.region.center = location.coordinate
                            }
                        }
                    }) {
                        Image(systemName: "location.fill")
                            .font(.title2)
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    MapView()
}
