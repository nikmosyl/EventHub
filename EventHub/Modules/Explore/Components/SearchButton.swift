//
//  SearchButton.swift
//  EventHub
//
//  Created by Drolllted on 09.09.2025.
//

import SwiftUI

struct SearchButton: View {
    var body: some View {
        HStack(spacing: 15){
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundStyle(.textLightSecondary)
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.textLightSecondary)
                .frame(width: 1, height: 20)
            Text("Search...")
                .font(.system(size: 20))
                .foregroundStyle(.textLightSecondary)
            
            Spacer()
            
            HStack(spacing: 5) {
                Image(systemName: "line.3.horizontal.decrease.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.textLightSecondary)
                
                Text("Filters")
                    .foregroundStyle(Color.textLightSecondary)
                    .font(.system(size: 14))
            }
            .background{
                Capsule()
                    .fill(Color.navBarSecondary)
                    .frame(width: 90, height: 35)
            }
        }
    }
}

#if DEBUG
#Preview {
    SearchButton()
        .preferredColorScheme(.dark)
}
#endif

