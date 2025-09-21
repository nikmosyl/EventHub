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
    
    @Published var pins: [PinModel] = []
    
    private let manager = CLLocationManager()
    private var debounceTask: Task<Void, Never>?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.lastLocation = location
        }
    }
    
    func updateRegion(lat: Double, lon: Double, radius: Int) {
            debounceTask?.cancel()
            
            debounceTask = Task {
                try? await Task.sleep(nanoseconds: 3_000_000_000)
                guard !Task.isCancelled else { return }
                
                await loadPins(lat: lat, lon: lon, radius: radius)
                
            }
        }
    
    @MainActor
    func loadPins(lat: Double, lon: Double, radius: Int) async {
            do {
                let events = try await DataManager.shared.getEventsByCoords(
                    lat: lat,
                    lon: lon,
                    radius: radius
                )
                pins = events.compactMap { PinModel(event: $0) }
            } catch {
                print("Ошибка загрузки событий: \(error)")
            }
        }

}
