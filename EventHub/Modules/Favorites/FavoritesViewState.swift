//
//  FavoritesViewState.swift
//  EventHub
//
//  Created by Николай Игнатов on 15.09.2025.
//

import Foundation

enum FavoritesViewState {
    case empty
    case loading
    case loaded
    case error(String)
}
