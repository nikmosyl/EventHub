//
//  WebURL.swift
//  EventHub
//
//  Created by Наташа Спиридонова on 19.09.2025.
//

import Foundation

struct WebURL: Identifiable {
    let id = UUID()
    let url: String
    
    init(_ url: String) {
        self.url = url
    }
}
