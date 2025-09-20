//
//  NotificationCard.swift
//  EventHub
//
//  Created by nikita on 20.09.2025.
//

import SwiftUI

struct NotificationCardView: View {
    @StateObject private var viewModel: NotificationCardViewModel
    
    init(notification: Event) {
        self._viewModel = StateObject(
            wrappedValue: NotificationCardViewModel(
                notification: notification
            )
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.notification.title ?? "Empty")
                .font(.system(size: 14))
                .fontWeight(.regular)
                .foregroundStyle(.textDarkPrimary)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
            
            Text(viewModel.calulatePeriod())
                .font(.system(size: 12))
                .fontWeight(.regular)
                .foregroundStyle(.textDarkSecondary)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.backgroundSecondary)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.borderPrimary, lineWidth: 1)
        )
        .shadow(color: Color.shadow, radius: 3, x: 0, y: 2)
        
    }
}

#Preview {
    NotificationCardView(notification: Event.preview)
}
