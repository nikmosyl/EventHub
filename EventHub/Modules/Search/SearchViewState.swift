//
//  SearchViewState.swift
//  EventHub
//
//  Created by Николай Игнатов on 17.09.2025.
//

enum SearchViewState {
    case empty
    case loading
    case loaded([Event])
    case error(String)
}
