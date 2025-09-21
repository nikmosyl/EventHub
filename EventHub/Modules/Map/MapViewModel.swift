//
//  MapViewModel.swift
//  EventHub
//
//  Created by nikita on 21.09.2025.
//

import Foundation
import MapKit

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var lastLocation: CLLocation?
    
    @Published var searchText = ""
    
    private let manager = CLLocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.lastLocation = location
        }
    }
    
    func loadPins(lat: Double, lon: Double, radius: Int) async {
        do {
            let events = try await DataManager.shared.getEventsByCoords(lat: lat, lon: lon, radius: radius)
            
            events.forEach { event in
                print(
                    "event id:", event.id ?? "???",
                    "lat:", event.location?.coords?.lat ?? "???",
                    "lon:", event.location?.coords?.lon ?? "???"
                )
            }
            
        } catch {
            print("не удалось загрузить map events, ошибка:", error)
        }
    }
}
