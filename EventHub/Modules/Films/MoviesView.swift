//
//  MoviesView.swift
//  EventHub
//
//  Created by Наташа Спиридонова on 22.09.2025.
//

import SwiftUI

struct MoviesView: View {
    @StateObject private var viewModel = MoviesViewModel()
    @State private var selectedWebURL: WebURL?
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            ScrollView {
                LazyVStack {
                    if let error = viewModel.errorText {
                        Text(error).foregroundStyle(.buttonColored)
                    }
                    ForEach(viewModel.items) { item in
                        MovieCellView(
                            poster: viewModel.processedPoster(for: item),
                            title: viewModel.processedTitle(for: item)
                        ) {
                            selectedWebURL = WebURL("https://kudago.com/spb/kino/")
                        }
                        .shadow(color: Color.shadow, radius: 5, x: 0, y: 6)
                    }
                    .padding(.top, 16)
                }
                if viewModel.isLoading {
                    ProgressView("Uploading films...")
                        .padding(.top, 12)
                }
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
                Text("Films")
                    .font(.system(size: 24))
                    .fontWeight(.regular)
                    .foregroundStyle(.textDarkPrimary)
                    .minimumScaleFactor(0.5)
            }
        }
        .task { await viewModel.load() }
        .sheet(item: $selectedWebURL) { webURL in
            WebView(url: webURL.url)
        }
    }
}

#Preview {
    NavigationStack {
        MoviesView()
    }
}
