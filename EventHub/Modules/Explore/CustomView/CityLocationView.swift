//
//  CityLocationView.swift
//  EventHub
//
//  Created by Drolllted on 09.09.2025.
//

import SwiftUI

struct CityLocationView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 5){
                    Text("City location")
                        .font(.system(size: 12))
                    Image(systemName: "arrowtriangle.down.fill")
                        .resizable()
                        .frame(width: 10, height: 5)
                }
                .foregroundStyle(Color.textLightSecondary)
                .fontWeight(.regular)
                
                Text("New York, USA")
                    .foregroundStyle(.black) //Change in White
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

#if DEBUG
#Preview{
    CityLocationView()
}
#endif
