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
    @Published var isLoading = false
    
    @Published var currentEvent: Event? = nil
    
    private let manager = CLLocationManager()
    private var debounceTask: Task<Void, Never>?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    @MainActor
    func searchEvents() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let searchResults = try await DataManager.shared.searchEvents(query: searchText)
            let ids: [Int] = searchResults.compactMap { $0.id }
            let events: [Event] = try await DataManager.shared.getEventsByIds(ids: ids)
            pins = events.compactMap { PinModel(event: $0) }
        } catch {
            print("Поиск по карте не удался", error)
        }
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
        isLoading = true
        debounceTask?.cancel()
        
        debounceTask = Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            guard !Task.isCancelled else { return }
            
            await loadPins(lat: lat, lon: lon, radius: radius)
        }
    }
    
    @MainActor
    func loadPins(lat: Double, lon: Double, radius: Int) async {
        isLoading = true
        defer { isLoading = false }
        
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
    
    @MainActor
    func loadEvent(id: Int) async {
        currentEvent = nil
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            currentEvent = try await DataManager.shared.getEvent(id: id)
        } catch {
            print("Не удалось загрузить event c id:", id)
        }
    }
    
}
