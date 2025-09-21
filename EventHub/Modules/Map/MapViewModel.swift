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
    
    @Published var events: [Event] = []
    
    private let manager = CLLocationManager()
    private var debounceTask: Task<Void, Never>?
    
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
    
    func updateRegion(lat: Double, lon: Double, radius: Int) {
        debounceTask?.cancel()
        
        debounceTask = Task {
            try? await Task.sleep(nanoseconds: 3_000_000_000) // ждём 3 сек
            guard !Task.isCancelled else { return }
            
            print("‼️ обновляем данные")
            await loadPins(lat: lat, lon: lon, radius: radius)
        }
    }
    
    func loadPins(lat: Double, lon: Double, radius: Int) async {
        do {
            events = try await DataManager.shared.getEventsByCoords(
                lat: lat,
                lon: lon,
                radius: radius
            )
            print("Загружено \(events.count) событий")
        } catch {
            print("Ошибка загрузки событий: \(error)")
        }
    }
}
