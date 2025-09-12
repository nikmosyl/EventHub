//
//  ExploreNavBar.swift
//  EventHub
//
//  Created by Drolllted on 12.09.2025.
//

import SwiftUI

struct ExploreNavBar: View {
    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .fill(Color.navBarPrimary)
                .frame(height: 200)
                .clipShape(
                    RoundedRectangleShape(radius: 33, corners: [.bottomLeft, .bottomRight])
                )
                .ignoresSafeArea(.all)
            
            VStack(spacing: 20) {
                CityLocationView()
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                
                Button {
                    // Go to Search Screen
                } label: {
                    SearchButton()
                        .padding(.horizontal, 20)
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    ExploreNavBar()
}
#endif
