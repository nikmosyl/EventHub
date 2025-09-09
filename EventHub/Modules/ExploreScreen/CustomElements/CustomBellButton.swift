//
//  CustomBellButton.swift
//  EventHub
//
//  Created by Drolllted on 09.09.2025.
//

import SwiftUI

struct CustomBellButton: View {
    var body: some View {
        ZStack {
            Image(systemName: "bell")
                .foregroundStyle(.white)
                .frame(width: 15, height: 15)
                .background{
                    Circle()
                        .fill(Color.navBarSecondary)
                        .frame(width: 36, height: 36)
                }
            
            Circle()
                .fill(Color.green)
                .frame(width: 5, height: 5)
                .background{
                    Circle()
                        .fill(Color.navBarSecondary)
                        .frame(width: 8, height: 8)
                }
                .offset(x: 6, y: -4)
        }
            
    }
}

#if DEBUG
#Preview {
    CustomBellButton()
}
#endif
