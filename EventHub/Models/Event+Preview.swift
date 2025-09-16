//
//  PreviewWrapper.swift
//  EventHub
//
//  Created by Наташа Спиридонова on 14.09.2025.
//


// MARK: - Extension Event + Preview
#if DEBUG
extension Event {
    static let preview = Event(
        id: 211064,
        title: "выставка «SENSE. Геометрия чувств»",
        slug: "vyistavka-sense-geometriya-chuvstv",
        description: "Масштабная иммерсивная выставка с использованием современных технологий возвращает человека к природе, задействуя все органы чувств.",
        shortTitle: "SENSE. Геометрия чувств",
        dates: [EventDate(
            start: -62135433000,
            end: 1759258800
        )],
        location: Location(
            slug: "msk",
            name: "",
            coords: Coords(
                lat: 55.768907,
                lon: 37.626951
            )
        ),
        place: Place(
            id: 936,
            title: "Центр современного искусства «М'АРС»",
            address: "пер. Пушкарёв, д. 5",
            subway: "Сухаревская, Трубная, Цветной бульвар",
            location: "msk",
            coords: Coords(
                lat: 55.768907,
                lon: 37.626951
            )
        ),
        price: "1200 руб. по будням, 1400 руб. по выходным",
        images: [Event.EventImage(
            image: "https://media.kudago.com/images/event/51/76/5176bd7df90450cf49fe68cc9d4b03a3.JPG",
            source: Event.EventImage.ImageSource(
                name: "",
                link: ""
            )
        )],
        favoritesCount: 100,
        siteUrl: "https://kudago.com/msk/event/vyistavka-sense-geometriya-chuvstv/",
        categories: ["exhibition"],
        participants: []
    )
}
#endif
