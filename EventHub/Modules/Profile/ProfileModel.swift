//
//  ProfileModel.swift
//  EventHub
//
//  Created by Николай Игнатов on 13.09.2025.
//

import Foundation

struct ProfileModel {
    let name: String
    let aboutMe: String

    init(from userModel: UserModel) {
        self.name = userModel.displayName
        self.aboutMe = userModel.bio
    }

    init(name: String, aboutMe: String) {
        self.name = name
        self.aboutMe = aboutMe
    }
}

extension ProfileModel {
    static let example = ProfileModel(from: UserModel(
        uid: "example-uid",
        displayName: "Ashfak Sayem",
        email: "ashfak@example.com",
        photoURL: "",
        bio: "Enjoy your favorite dishe and a lovely your friends and family and have a great time. Food from local food trucks will be available for purchase. Enjoy your favorite dishe and a lovely your friends and family and have a great time. Food from local food trucks will be available for purchase. Enjoy your favorite dishe and a lovely your friends and family and have a great time. Food from local food trucks will be available for purchase.",
        favoritesIds: []
    ))
}
