//
//  EventCellView.swift
//  EventHub
//
//  Created by Наташа Спиридонова on 10.09.2025.
//

import SwiftUI

struct EventCellView: View {
    @StateObject private var viewModel: EventCellViewModel
    
    init(event: Event) {
        self._viewModel = StateObject(wrappedValue: EventCellViewModel(event: event))
    }
    
    var body: some View {
        // изображение
        HStack(alignment: .top) {
            NetworkImage(imageUrl: viewModel.imageURL ?? "")
            .frame(width: 79, height: 92)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            
            VStack(alignment: .leading) {
                // дата и время
                Text(viewModel.dateTime)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.buttonPrimary)
                
                // название
                Text(viewModel.title)
                    .font(.system(size: 15))
                    .fontWeight(.medium)
                    .foregroundStyle(.textDarkPrimary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                    
                // локация
                HStack {
                    Image("Map")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 11, height: 13)
                        .foregroundStyle(.textDarkSecondary)
                    
                    Text(viewModel.location)
                        .font(.subheadline)
                        .foregroundStyle(.textDarkSecondary)
                        .lineLimit(2)
                        .truncationMode(.tail)
                }
            }
            
            Spacer()
            
            // избранное
            Button(action: viewModel.toggleBookmark) {
                Image(systemName: viewModel.isBookmarked ? "bookmark.fill" : "bookmark")
                    .resizable()
                    .frame(width: 11, height: 13)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.buttonCalored)
                    .scaleEffect(viewModel.isLoading ? 0.8 : 1)
                    .animation(.easeInOut(duration: 0.2), value:  viewModel.isLoading)
            }
            .disabled(viewModel.isLoading)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
        )
        .padding(.horizontal)
    }
    
    private var placeholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.textDarkSecondary)
            Image(systemName: "photo")
                .font(.title2)
                .foregroundStyle(.tertiary)
        }
    }
}

#Preview {
    EventCellView(event: Event.preview)
}
