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
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ZStack(alignment: .top) {
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
                                .padding(.horizontal, 20)
                            
                            Button {
                                // Go to Search
                            } label: {
                                SearchButton()
                            }
                            .padding(.horizontal, 20)
                            
                            VariableSectionView()
                                .padding(.leading, 20)
                                .offset(y: 10)
                            
                            VariableSectionView()
                                .padding(.leading, 20)
                                .offset(y: 10)
                            
                            VStack(spacing: 20) {
                                HStack {
                                    Text("Upcoming Events")
                                        .font(.system(size: 18))
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    Text("See All")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                }
                                .padding(.horizontal, 20)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        EventsCard()
                                        EventsCard()
                                        EventsCard()
                                    }
                                    .padding(.horizontal, 20)
                                }
                                
                                HStack {
                                    Text("Nearby You")
                                        .font(.system(size: 18))
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    Text("See All")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                }
                                .padding(.horizontal, 20)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        EventsCard()
                                        EventsCard()
                                    }
                                    .padding(.horizontal, 20)
                                }
                            }
                            .padding(.top, 20)
                            .background(Color.white)
                        }
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#if DEBUG
#Preview {
    ExploreView()
}
#endif
