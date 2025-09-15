//
//  FavoritesViewState.swift
//  EventHub
//
//  Created by Николай Игнатов on 15.09.2025.
//

import Foundation

enum FavoritesViewState {
    case initial
    case loading
    case empty
    case loaded([Event])
    case error(String)
}
