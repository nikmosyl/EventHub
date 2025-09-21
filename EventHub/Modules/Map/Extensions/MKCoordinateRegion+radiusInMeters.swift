//
//  MKCoordinateRegion+radiusInMeters.swift
//  EventHub
//
//  Created by nikita on 21.09.2025.
//

import MapKit

extension MKCoordinateRegion {
    var radiusInMeters: CLLocationDistance {
        let centerLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
        
        let halfLongitudeDelta = span.longitudeDelta / 2
        let eastCoord = CLLocation(
            latitude: center.latitude,
            longitude: center.longitude + halfLongitudeDelta
        )
        
        return centerLocation.distance(from: eastCoord)
    }
}

struct EquatableRegion: Equatable {
    var region: MKCoordinateRegion
    
    static func == (lhs: EquatableRegion, rhs: EquatableRegion) -> Bool {
        lhs.region.center.latitude == rhs.region.center.latitude &&
        lhs.region.center.longitude == rhs.region.center.longitude &&
        lhs.region.span.latitudeDelta == rhs.region.span.latitudeDelta &&
        lhs.region.span.longitudeDelta == rhs.region.span.longitudeDelta
    }
}

