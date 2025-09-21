//
//  ProButtons.swift
//  EventHub
//
//  Created by Drolllted on 21.09.2025.
//

import SwiftUI

struct ProButtons: View {
    
    @StateObject var viewModel = ProButtonsViewModel()
    
    init() {
        self._viewModel = StateObject(wrappedValue: ProButtonsViewModel())
    }
    
    var body: some View {
        HStack(spacing: 16) {
            
            //MARK: - Today Button
            Button {
                Task {
                   try await print(viewModel.fetchLists())
                }
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
    }
}
