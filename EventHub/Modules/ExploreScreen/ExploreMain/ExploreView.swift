//
//  ExploreView.swift
//  EventHub
//
//  Created by Drolllted on 09.09.2025.
//

import SwiftUI

struct ExploreView: View {
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                ZStack {
                    Rectangle()
                        .fill(Color.navBarPrimary)
                        .frame(height: 200)
                        .clipShape(
                            RoundedRectangleShape(radius: 33,
                                                  corners: [.bottomLeft, .bottomRight])
                        )
                        .ignoresSafeArea(.all)
                        .offset(y: -65)
                    
                    VStack(spacing: 20) {
                        CityLocationView()
                        
                        Button {
                            // Go to Search
                        } label: {
                            SearchButton()
                        }

                    }
                    .offset(y: -50)
                    .padding(.horizontal, 20)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#if DEBUG
#Preview {
    ExploreView()
}
#endif
