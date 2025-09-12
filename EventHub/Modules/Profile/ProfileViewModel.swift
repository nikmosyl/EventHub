//
//  ProfileViewModel.swift
//  EventHub
//
//  Created by Николай Игнатов on 13.09.2025.
//

import Foundation

final class ProfileViewModel: ObservableObject {
    @Published var profile: ProfileModel
    @Published var isShowingFullAbout: Bool = false
    @Published var isEditingMode: Bool = false
    @Published var showingNameAlert: Bool = false
    @Published var showingAboutAlert: Bool = false
    @Published var showingPhotoPicker: Bool = false
    @Published var tempName: String = ""
    @Published var tempAboutMe: String = ""
    
    init(profile: ProfileModel) {
        self.profile = profile
        self.tempName = profile.name
        self.tempAboutMe = profile.aboutMe
    }
    
    func onEditProfileTapped() {
        print("Edit Profile button tapped")
        isEditingMode = true
    }
    
    func onSaveProfileTapped() {
        isEditingMode = false
        print("Saving profile to data service...")
    }
    
    func onEditAvatarTapped() {
        print("Edit Avatar button tapped")
        showingPhotoPicker = true
    }
    
    func onEditNameTapped() {
        print("Edit Name button tapped")
        tempName = profile.name
        showingNameAlert = true
    }
    
    func onEditAboutTapped() {
        print("Edit About button tapped")
        tempAboutMe = profile.aboutMe
        showingAboutAlert = true
    }
    
    func updateName() {
        print("Updating name from '\(profile.name)' to '\(tempName)' in data service")
        profile = ProfileModel(name: tempName, aboutMe: profile.aboutMe)
    }
    
    func updateAbout() {
        print("Updating about from '\(profile.aboutMe)' to '\(tempAboutMe)' in data service")
        profile = ProfileModel(name: profile.name, aboutMe: tempAboutMe)
    }
    
    func onReadMoreTapped() {
        print("Read More button tapped")
        isShowingFullAbout.toggle()
    }
    
    func onSignOutTapped() {
        print("Sign Out button tapped")
    }
}
