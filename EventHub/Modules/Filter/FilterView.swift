//
//  FilterView.swift
//  EventHub
//
//  Created by nikita on 22.09.2025.
//

import SwiftUI

struct FilterView: View {
    @Binding var filter: EventFilters
    
    var body: some View {
        VStack {
            VStack {
                Text("Filter")
                Spacer()
            }
            
            
        }
    }
}

#Preview {
    FilterView(filter: .constant(EventFilters()))
}
