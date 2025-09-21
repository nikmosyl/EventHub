//
//  MapToolbar.swift
//  EventHub
//
//  Created by nikita on 21.09.2025.
//

import SwiftUI

struct MapToolbar: View {
    @Binding var searchText: String
    
    let onCenterTap: () -> ()
    
    var body: some View {
            VStack {
                HStack(spacing: 12) {
                    TextField(
                        "Find for food or restaurant...",
                        text: $searchText
                    )
                    .padding(15)
                    .background(Color.background)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.borderPrimary, lineWidth: 2)
                    )
                    .cornerRadius(12)
                    
                    Button {
                        onCenterTap()
                    } label: {
                        Image("Center")
                            .resizable()
                            .frame(width: 22, height: 22)
                            .padding(15)
                            .background(Color.background)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.borderPrimary, lineWidth: 2)
                            )
                            .cornerRadius(12)
                    }

                }
                .padding(.horizontal, 25)
                
                Spacer()
            }
    }
}

#Preview {
    MapToolbar(searchText: .constant(""), onCenterTap: {})
}
