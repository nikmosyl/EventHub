//
//  ExploreView.swift
//  EventHub
//
//  Created by Drolllted on 09.09.2025.
//

import SwiftUI

struct ExploreView: View {
    
    @StateObject var vm = ExploreViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            
            ExploreNavBar()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    Spacer()
                        .frame(height: 90)
                    
                    VariableSectionView(categories: vm.getCategoryViewModel())
                        .offset(y: 5)
                    
                    VariableSectionView(categories: vm.getCategoryViewModel())
                        .offset(y: 5)
                    
                    VStack(spacing: 5) {
                        HStack {
                            Text("Upcoming Events")
                                .font(.system(size: 18))
                                .foregroundStyle(Color.textDarkPrimary)
                            Spacer()
                            
                            Button {
                                
                            } label: {
                                Text("See All")
                                    .foregroundStyle(Color.textDarkSecondary)
                                    .font(.system(size: 14))
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Upcoming Events ForEach
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(0..<3) { _ in
                                    EventsCard()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
