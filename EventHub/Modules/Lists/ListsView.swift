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
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if let error = viewModel.errorText {
                    Text(error).foregroundStyle(.buttonCalored)
                }
                ForEach(viewModel.items) { item in
                    ListCellView(title: item.title ?? "Без названия") {
                        if let url = item.siteUrl {
                            selectedWebURL = WebURL(url)
                        }
                    }
                    .padding(.top, 16)
                }
                if viewModel.isLoading {
                    ProgressView("Загрузка подборок...")
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
                Text("Lists")
                    .font(.system(size: 24))
                    .fontWeight(.regular)
                    .foregroundStyle(.textDarkPrimary)
                    .minimumScaleFactor(0.7)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: {
                    Text("Экран поиска будет реализован позднее...")
                }, label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.textDarkPrimary)
                })
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
