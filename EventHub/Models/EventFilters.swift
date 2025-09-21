//
//  EventFilters.swift
//  EventHub
//
//  Created by Наташа Спиридонова on 16.09.2025.
//


import Foundation

// MARK: - Фильтры для событий
struct EventFilters {
    let location: String?
    let actualSince: Int?
    let actualUntil: Int?
    let categories: [String]?
    let price: String?
    let search: String?
    let page: Int?
    let pageSize: String?
    let fields: [String]?
    let expand: [String]?
    let ids: String?
    let lat: Double?
    let lon: Double?
    let radious: Int?
    
    init(
        location: String? = nil,
        actualSince: Int? = nil,
        actualUntil: Int? = nil,
        categories: [String]? = nil,
        search: String? = nil,
        page: Int? = nil,
        pageSize: String? = nil,
        price: String? = nil,
        fields: [String]? = nil,
        expand: [String]? = nil,
        ids: String? = nil,
        lat: Double? = nil,
        lon: Double? = nil,
        radious: Int? = nil
    ) {
        self.location = location
        self.actualSince = actualSince
        self.actualUntil = actualUntil
        self.categories = categories
        self.search = search
        self.page = page
        self.pageSize = pageSize
        self.price = price
        self.fields = fields
        self.expand = expand
        self.ids = ids
        self.lat = lat
        self.lon = lon
        self.radious = radious
    }
}
