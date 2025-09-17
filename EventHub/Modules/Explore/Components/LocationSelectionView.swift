//
//  LocationSelectionView.swift
//  EventHub
//
//  Created by Drolllted on 17.09.2025.
//

import SwiftUI

struct LocationSelectionView: View {
    
    let locations: [Location]
    let onSelect: (String) -> Void
    let currentLocationSlug: String
    
    var body: some View {
        NavigationView {
            List(locations, id: \.slug) { location in
                if let slug = location.slug, let name = location.name {
                    Button {
                        onSelect(slug)
                    } label: {
                        HStack {
                            Text(name)
                                .foregroundColor(.primary)
                            Spacer()
                            if slug == currentLocationSlug {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Choose City")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
