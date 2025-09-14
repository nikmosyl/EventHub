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
                    
                    switch vm.state {
                    case .idle, .loading:
                        ProgressView()
                            .frame(height: 200)
                    case .loaded(let explorerContent):
                        EventsCollectionView()
                            .environmentObject(vm)
                    case .error(let error):
                        ErrorView(error: error) {
                            Task {
                                await vm.loadInitialData()
                            }
                        }
                    }
                }
            }
        }
        .task {
            await vm.loadInitialData()
        }
    }
}
