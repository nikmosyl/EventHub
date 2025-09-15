//
//  ProfileViewModel.swift
//  EventHub
//
//  Created by Николай Игнатов on 13.09.2025.
//

import FirebaseStorage
import UIKit

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var profile: ProfileModel?
    @Published var isEditingMode: Bool = false
    @Published var showingNameAlert: Bool = false
    @Published var showingAboutAlert: Bool = false
    @Published var showingPhotoPicker: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    @Published var tempName: String = ""
    @Published var tempAboutMe: String = ""
    @Published var profileImage: UIImage?
    
    private let dataManager = DataManager.shared
    
    init() {
        loadUserData()
    }
    
    func loadUserData() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let userModel = try await dataManager.getUserData()
                profile = ProfileModel(from: userModel)
                tempName = profile?.name ?? ""
                tempAboutMe = profile?.aboutMe ?? ""

                if !userModel.photoURL.isEmpty {
                    await loadProfileImage(from: userModel.photoURL)
                }
            } catch {
                errorMessage = "Failed to load user data: \(error.localizedDescription)"
            }
            isLoading = false
        }
    }
    
    func uploadPhoto(data: Data) {
        #warning("dataManager.uploadUserPhoto кидает 404")
//        Task {
//            try? await dataManager.uploadUserPhoto(data: data)
//        }
        if let image = UIImage(data: data) {
            profileImage = image
        }
    }
    
    func onEditProfileTapped() {
        guard let profile = profile else { return }
        tempName = profile.name
        tempAboutMe = profile.aboutMe
        isEditingMode = true
    }
    
    func onSaveProfileTapped() {
        isEditingMode = false

        Task {
            do {
                try await dataManager.updateUserData(
                    displayName: tempName,
                    bio: tempAboutMe
                )
                refreshUserData()
            } catch {
                errorMessage = "Failed to save profile: \(error.localizedDescription)"
            }
        }
    }
    
    func onEditAvatarTapped() {
        showingPhotoPicker = true
    }
    
    func onEditNameTapped() {
        tempName = profile?.name ?? ""
        showingNameAlert = true
    }
    
    func onEditAboutTapped() {
        tempAboutMe = profile?.aboutMe ?? ""
        showingAboutAlert = true
    }
    
    func updateName() {
        if let currentProfile = profile {
            profile = ProfileModel(
                name: tempName,
                aboutMe: currentProfile.aboutMe
            )
        }
    }

    func updateAbout() {
        if let currentProfile = profile {
            profile = ProfileModel(
                name: currentProfile.name,
                aboutMe: tempAboutMe
            )
        }
    }
    
    func onSignOutTapped() {
        do {
            try dataManager.logoutUser()
        } catch {
            errorMessage = "Failed to sign out: \(error.localizedDescription)"
        }
    }
}

private extension ProfileViewModel {
    func loadProfileImage(from urlString: String) async {
        guard let url = URL(string: urlString) else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                await MainActor.run {
                    profileImage = image
                }
            }
        } catch {
            errorMessage = "Failed to load profile image: \(error.localizedDescription)"
        }
    }
    
    func refreshUserData() {
        Task {
            do {
                let userModel = try await dataManager.getUserData()
                profile = ProfileModel(from: userModel)

                if !userModel.photoURL.isEmpty {
                    await loadProfileImage(from: userModel.photoURL)
                }
            } catch {
                errorMessage = "Failed to refresh user data: \(error.localizedDescription)"
            }
        }
    }
}
