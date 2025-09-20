//
//  NotificationEmptyView.swift
//  EventHub
//
//  Created by nikita on 20.09.2025.
//

import SwiftUI

struct NotificationEmptyView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image("EmptyNotification")
                .resizable()
                .frame(width: 155, height: 169)
            
            
            Text("No Notifications!")
                .font(.system(size: 18))
                .fontWeight(.medium)
                .foregroundStyle(.textDarkPrimary)
            
            Text("There are no notifications here yet, but when you add something to your bookmarks, we will notify you in advance about upcoming events.")
                .font(.system(size: 16))
                .fontWeight(.regular)
                .foregroundStyle(.textDarkSecondary)
                .lineSpacing(8)
        }
        .padding(24)
    }
}

#Preview {
    NotificationEmptyView()
}
