//
//  EventHubLogoView.swift
//  EventHub
//
//  Created by Mikhail Ustyantsev on 08.09.2025.
//

import SwiftUI

struct EventHubLogoView: View {
    var body: some View {
        VStack(spacing: 4) {
            Image("EventLogo")
                .offset(x: -10)
            
            Text("EventHub")
                .font(.system(size: 35, weight: .semibold))
        }
    }
}

#Preview {
    EventHubLogoView()
}
