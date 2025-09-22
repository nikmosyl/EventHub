//
//  EvenstView.swift
//  EventHub
//
//  Created by nikita on 22.09.2025.
//

import SwiftUI

struct EventsView: View {
    @StateObject private var viewModel = EventsViewModel()
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Events")
                    .font(.system(size: 24))
                    .fontWeight(.medium)
                    .foregroundStyle(.textDarkPrimary)
                
                HStack {
                    Text("UPCOMING")
                        .font(.system(size: 15))
                        .fontWeight(.regular)
                        .foregroundStyle(viewModel.upcoming ? .buttonPrimary : .textDarkSecondary)
                        .frame(width: 295/2 - 10, height: 45 - 10)
                        .background(
                            RoundedRectangle(cornerRadius: (45 - 10) / 2)
                                .foregroundStyle(viewModel.upcoming ? Color.background : Color.clear)
                        )
                        .cornerRadius(12)
                    
                    Text("PAST EVENTS")
                        .font(.system(size: 15))
                        .fontWeight(.regular)
                        .foregroundStyle(!viewModel.upcoming ? .buttonPrimary : .textDarkSecondary)
                        .frame(width: 295/2 - 10, height: 45 - 10)
                        .background(
                            RoundedRectangle(cornerRadius: (45 - 10) / 2)
                                .foregroundStyle(!viewModel.upcoming ? Color.background : Color.clear)
                        )
                        .cornerRadius(12)
                }
                .frame(width: 295, height: 45)
                .background(
                    RoundedRectangle(cornerRadius: 45 / 2)
                        .foregroundStyle(Color.backgroundSecondary)
                )
                .cornerRadius(12)
                .onTapGesture {
                    withAnimation {
                        viewModel.upcoming.toggle()
                        viewModel.toggleSwitch()
                    }
                }
                
                if viewModel.events.isEmpty {
                    Spacer()
                    CustomProgressView()
                        .scaleEffect(2)
                }
                
                VStack {
                    ForEach(viewModel.events.prefix(3)) { event in
                        EventCellView(event: event)
                            .padding(.horizontal, 24)
                    }
                }
                
                Spacer()
                
                NavigationLink {
                    SeeAllView(events: viewModel.events)
                } label: {
                    HStack {
                        Color.clear
                            .frame(width: 30, height: 30)
                        
                        Spacer()
                        
                        Text("EXPLORE EVENTS")
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            .foregroundStyle(Color.textLightPrimary)
                        
                        Spacer()
                        
                        Image(systemName: "arrow.forward")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 13, height: 13)
                            .foregroundColor(.textLightPrimary)
                            .background(
                                Circle()
                                    .fill(Color.buttonSecondary)
                                    .frame(width: 30, height: 30)
                            )
                    }
                    .padding(.horizontal, 24)
                }
                .frame(width: 271, height: 58)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(Color.buttonPrimary)
                )
                .cornerRadius(12)
                .padding(.bottom, 20)
                
            }
        }
    }
}

#Preview {
    EventsView()
}
