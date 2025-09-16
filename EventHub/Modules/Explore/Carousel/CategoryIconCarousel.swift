//
//  CategoryIconCarousel.swift
//  EventHub
//
//  Created by Drolllted on 16.09.2025.
//

import Foundation

struct CategoryIconCarousel {
    static let icons: [String: String] = [
        "События для бизнеса": "briefcase",
        "Кинопоказы": "film",
        "Концерты": "music.note",
        "Обучение": "book",
        "Развлечения": "party.popper",
        "Выставки": "rectangle.grid.2x2",
        "Мода и стиль": "hanger",
        "Фестивали": "flag",
        "Праздники": "gift",
        "Детям": "teddybear",
        "Разное": "ellipsis",
        "Вечеринки": "music.mic",
        "Фотография": "camera",
        "Квесты": "puzzlepiece",
        "Активный отдых": "figure.run",
        "Шопинг (Магазины)": "cart",
        "Благотворительность": "heart",
        "Акции и скидки": "tag",
        "Спектакли": "theatermasks",
        "Экскурсии": "map",
        "Ярмарки (Развлечения, Ярмарки)": "tent"
    ]
    
    static func icon(for categoryName: String) -> String {
        return icons[categoryName] ?? "pencil"
    }
}
