//
//  SearchEmptyView.swift
//  EventHub
//
//  Created by nikita on 16.09.2025.
//

import SwiftUI

struct SearchEmptyView: View {
    var body: some View {
        Text("NO RESULTS")
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.primary)
    }
}

#Preview {
    SearchEmptyView()
}
