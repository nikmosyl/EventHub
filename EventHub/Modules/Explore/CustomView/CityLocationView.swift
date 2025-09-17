//
//  CityLocationView.swift
//  EventHub
//
//  Created by Drolllted on 09.09.2025.
//

import SwiftUI

struct CityLocationView: View {
    
    @Binding var showCurrentLocation: Bool
    let currentLocation: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 5){
                    
                    Button {
                        showCurrentLocation = true
                    } label: {
                        Text("City location")
                            .font(.system(size: 12))
                    }
                    Image(systemName: "arrowtriangle.down.fill")
                        .resizable()
                        .frame(width: 10, height: 5)
                }
                .foregroundStyle(Color.textLightSecondary)
                .fontWeight(.regular)
                
                Text(currentLocation)
                    .foregroundStyle(.white)
                    .fontWeight(.regular)
                    .font(.system(size: 13))
            }
            
            Spacer()
            
            Button {
                print("12334")
            } label: {
                CustomBellButton()
            }

        }
    }
}

