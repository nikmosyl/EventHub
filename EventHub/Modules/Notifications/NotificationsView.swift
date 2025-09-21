//
//  Notification.swift
//  EventHub
//
//  Created by Анастасия Тихонова on 18.09.2025.
//

import SwiftUI

struct NotificationsView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel = NotificationsViewModel()
    
    var body: some View {
        VStack {
            if  viewModel.isLoading{
                ProgressView("Uploading lists...")
            } else if viewModel.notifications.isEmpty{
                NotificationEmptyView()
            } else {
                ScrollView {
                    VStack {
                        ForEach(viewModel.notifications) { notification in
                            NotificationCardView(notification: notification)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left")
                        .foregroundStyle(.textDarkPrimary)
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Text("Notification")
                    .font(.system(size: 24))
                    .fontWeight(.regular)
                    .foregroundStyle(.textDarkPrimary)
                    .minimumScaleFactor(0.7)
            }
        }
        .task {
            await viewModel.loadNotifications()
        }
    }
}
