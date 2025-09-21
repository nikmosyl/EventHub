//
//  MapPin.swift
//  EventHub
//
//  Created by nikita on 21.09.2025.
//

import SwiftUI

struct MapPin: View {
    let icon: String
    let color: Color
    
    var body: some View {
        ZStack {
            Image("MapPin")
                .renderingMode(.template)
                .resizable()
                .foregroundStyle(Color.background)
                .scaledToFit()
                .frame(width: 46, height: 46)
                .shadow(radius: 2)
            
            Image(systemName: icon)
                .foregroundStyle(Color.textLightPrimary)
                .scaledToFit()
                .frame(width: 34, height: 34)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .offset(y: -2.5)
                
        }
    }
}

#Preview {
    MapPin(icon: "folder", color: .red)
}
