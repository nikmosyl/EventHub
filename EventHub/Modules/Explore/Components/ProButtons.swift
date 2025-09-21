//
//  ProButtons.swift
//  EventHub
//
//  Created by Drolllted on 21.09.2025.
//

import SwiftUI

struct ProButtons: View {
    
    let todayEvent: () -> Void
    let filmsEvent: () -> Void
    let listsEvent: () -> Void
    @Binding var showOnlyToday: Bool
    @Binding var showOnlyFilms: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            
            // Today Button
            Button {
                if showOnlyToday {
                    // Если уже активна, деактивируем
                    showOnlyToday = false
                } else {
                    todayEvent()
                    showOnlyToday = true
                    showOnlyFilms = false
                }
            } label: {
                Text("TODAY")
                    .foregroundStyle(showOnlyToday ? .white : .textLightPrimary)
                    .font(.system(size: 15, weight: .medium))
                    .frame(width: 107, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(showOnlyToday ? Color.blue : Color.buttonSecondary)
                    )
            }
            
            // Films Button
            Button {
                if showOnlyFilms {
                    // Если уже активна, деактивируем
                    showOnlyFilms = false
                } else {
                    filmsEvent()
                    showOnlyFilms = true
                    showOnlyToday = false
                }
            } label: {
                Text("FILMS")
                    .foregroundStyle(showOnlyFilms ? .white : .textLightPrimary)
                    .font(.system(size: 15, weight: .medium))
                    .frame(width: 107, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(showOnlyFilms ? Color.blue : Color.buttonSecondary)
                    )
            }
            
            // Lists Button
            Button {
                listsEvent()
            } label: {
                Text("LISTS")
                    .foregroundStyle(.textLightPrimary)
                    .font(.system(size: 15, weight: .medium))
                    .frame(width: 107, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.buttonSecondary)
                    )
            }
        }
        .padding(.horizontal, 16)
    }
}
