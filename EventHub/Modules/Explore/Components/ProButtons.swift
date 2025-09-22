//
//  ProButtons.swift
//  EventHub
//
//  Created by Drolllted on 21.09.2025.
//

import SwiftUI

struct ProButtons: View {
    @StateObject var viewModel: ProButtonsViewModel
    let location: String
    
    init(location: String) {
        self.location = location
        _viewModel = StateObject(wrappedValue: ProButtonsViewModel(location: location))
    }
    
    var body: some View {
        HStack(spacing: 16) {
            
            //MARK: - Today Button
            NavigationLink {
                SeeAllView(events: viewModel.todayEvents)
            } label: {
                Text("TODAY")
                    .foregroundStyle(.textLightPrimary)
                    .font(.system(size: 15, weight: .medium))
                    .frame(width: 107, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.buttonSecondary)
                    )
            }
            
            
            //MARK: - Films
            NavigationLink {
                //Text("Screen with films in development")
                SeeAllView(events: viewModel.filmsEvents)
            } label: {
                Text("FILMS")
                    .foregroundStyle(.textLightPrimary)
                    .font(.system(size: 15, weight: .medium))
                    .frame(width: 107, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.buttonSecondary)
                    )
            }
            
            //MARK: - Lists
            
            NavigationLink {
                ListsView()
            } label: {
                Text("LISTS")
                    .foregroundStyle(.textLightPrimary)
                    .font(.system(size: 15, weight: .medium))
                    .frame(width: 107, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.buttonSecondary)
                    )
            }
            
        }
        .padding(.horizontal, 16)
        .onChange(of: location) { newLocation in
            Task {
                await viewModel.loadTodays(location: newLocation)
                await viewModel.loadFilms(location: newLocation)
            }
        }
    }
}
