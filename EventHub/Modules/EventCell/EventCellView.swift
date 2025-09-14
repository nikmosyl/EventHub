//
//  EventCellView.swift
//  EventHub
//
//  Created by Наташа Спиридонова on 10.09.2025.
//

import SwiftUI

struct EventCellView: View {
    @StateObject private var viewModel: EventCellViewModel
    
    init(viewModel: EventCellViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: viewModel.imageURL) { phase in
                switch phase {
                case .empty:
                    placeholder
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure(_):
                    placeholder
                @unknown default:
                    placeholder
                }
            }
            .frame(width: 79, height: 92)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            
            VStack(alignment: .leading) {
                Text(viewModel.dateTime)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.buttonPrimary)
                
                Text(viewModel.title)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.textDarkPrimary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                    
                
                HStack {
                    Image(systemName: "location.circle")
                        .font(.subheadline)
                        .foregroundStyle(.textDarkSecondary)
                    
                    Text(viewModel.location)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }
            
            Spacer()
            
            Button(action: viewModel.toggleBookmark) {
                Image(systemName: viewModel.isBookmarked ? "bookmark.fill" : "bookmark")
                    .resizable()
                    .frame(width: 17, height: 19)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.buttonCalored)
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
                .fill(.backgroundSecondary)
            Image(systemName: "photo")
                .font(.title2)
                .foregroundStyle(.tertiary)
        }
    }
}

#Preview {
    PreviewWrapper()
}

struct PreviewWrapper: View {
    @State private var viewModel: EventCellViewModel?
    
    var body: some View {
        VStack {
            if let viewModel = viewModel {
                EventCellView(viewModel: viewModel)
            } else {
                ProgressView("Загрузка события...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .task {
            do {
                let events = try await DataManager.shared.getUpcamingEvents()
                if let firstEvent = events.first {
                    viewModel = EventCellViewModel(event: firstEvent)
                }
            } catch {
                print("Ошибка загрузки: \(error)")
            }
        }
    }
}
