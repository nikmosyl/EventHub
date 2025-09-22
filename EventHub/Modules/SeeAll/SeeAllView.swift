//
//  SeeAllView.swift
//  EventHub
//
//  Created by nikita on 22.09.2025.
//

import SwiftUI

struct SeeAllView: View {
    @Environment(\.dismiss) var dismiss
    
    let events: [Event]
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(events) { event in
                    EventCellView(event: event)
                    .padding(.horizontal, 16)
                }
            }
            .safeAreaInset(edge: .top) {
                Color.clear.frame(height: 20)
            }
        }
        .navigationBarBackButtonHidden()
        .background(Color.background.ignoresSafeArea())
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left")
                        .foregroundStyle(.textDarkPrimary)
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Text("Events")
                    .font(.system(size: 24))
                    .fontWeight(.regular)
                    .foregroundStyle(.textDarkPrimary)
                    .minimumScaleFactor(0.7)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: {
                    Text("The search screen will be implemented later...")
                }, label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.textDarkPrimary)
                })
            }
        }
    }
}

#Preview {
    SeeAllView(events: [Event.preview])
}
