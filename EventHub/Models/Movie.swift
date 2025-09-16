//
//  Movie.swift
//  EventHub
//
//  Created by Наташа Спиридонова on 16.09.2025.
//


import Foundation

// MARK: - Фильм
struct Movie: Decodable, Sendable {
    let id: Int
    let title: String
    let poster: MoviePoster?
    
    // MARK: - Постер фильма
    struct MoviePoster: Decodable, Sendable {
        let image: String
        let source: PosterSource?
        
        // MARK: - Источник постера
        struct PosterSource: Decodable, Sendable {
            let name: String
            let link: String
        }
    }
}
