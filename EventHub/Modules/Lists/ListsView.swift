//
//  ListsView.swift
//  EventHub
//
//  Created by Наташа Спиридонова on 19.09.2025.
//

import SwiftUI

struct ListsView: View {
    @StateObject private var viewModel = ListsViewModel()
    @State private var selectedWebURL: WebURL?
    @State private var isWebViewPresented = false
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 40) {
                if let error = viewModel.errorText {
                    Text(error).foregroundStyle(.buttonCalored)
                }
                ForEach(viewModel.items) { item in
                    ListCellView(title: item.title ?? "Без названия") {
                        if let url = item.siteUrl {
                            selectedWebURL = WebURL(url)
                        }
                    }
                    .frame(height: 106)
                }
                    
                if viewModel.isLoading {
                    ProfileView().padding(.top, 12)
                }
            }
        }
        .background(Color.background.ignoresSafeArea())
        .navigationTitle("Lists")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { /* поиск */ }) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.textDarkPrimary)
                }
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
        ListsView()
    }
}
