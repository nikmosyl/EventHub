//
//  SearchView.swift
//  EventHub
//
//  Created by Наташа Спиридонова on 19.09.2025.
//

import SwiftUI

struct SearchView: View {
    @Binding var searchText: String
    let onSearch: (String) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HStack {
                    TextField("Поиск по подборкам...", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                    
                    if !searchText.isEmpty {
                        Button("Очистить") {
                            searchText = ""
                        }
                        .foregroundStyle(.red)
                    }
                }
                .padding(.horizontal)
                
                Button("Найти") {
                    onSearch(searchText)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .disabled(searchText.isEmpty)
                
                Spacer()
            }
            .navigationTitle("Поиск")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SearchView(
        searchText: .constant(""),
        onSearch: { query in
            print("Поиск: \(query)")
        }
    )
}
