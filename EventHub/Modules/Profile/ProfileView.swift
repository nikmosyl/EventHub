//
//  ProfileView.swift
//  EventHub
//
//  Created by Николай Игнатов on 13.09.2025.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    
    var body: some View {
        NavigationView {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let profile = viewModel.profile {
                VStack(spacing: 32) {
                    Text("Profile")
                        .font(.system(size: 24))
                        .fontWeight(.medium)
                    
                    ProfileHeader(
                        avatarImage: selectedImage ?? viewModel.profileImage,
                        name: profile.name,
                        isEditingMode: viewModel.isEditingMode,
                        onEditProfileTapped: viewModel.onEditProfileTapped,
                        onEditAvatarTapped: viewModel.onEditAvatarTapped,
                        onEditNameTapped: viewModel.onEditNameTapped
                    )
                    
                    AboutSection(
                        aboutText: profile.aboutMe,
                        isEditingMode: viewModel.isEditingMode,
                        onEditAboutTapped: viewModel.onEditAboutTapped
                    )
                    .padding(.horizontal, 20)
                    .frame(maxHeight: .infinity)
                    
                    if viewModel.isEditingMode {
                        SaveButton(
                            onSaveTapped: viewModel.onSaveProfileTapped
                        )
                    } else {
                        SignOutButton(
                            onSignOutTapped: viewModel.onSignOutTapped
                        )
                    }
                }
                .padding(.bottom, 120)
            }
        }
        .alert("Edit Name", isPresented: $viewModel.showingNameAlert) {
            TextField("Name", text: $viewModel.tempName)
            Button("Cancel", role: .cancel) { }
            Button("Done") {
                viewModel.updateName()
            }
        } message: {
            Text("Enter your new name")
        }
        .alert("Edit About Me", isPresented: $viewModel.showingAboutAlert) {
            TextField("About Me", text: $viewModel.tempAboutMe, axis: .vertical)
            Button("Cancel", role: .cancel) { }
            Button("Done") {
                viewModel.updateAbout()
            }
        } message: {
            Text("Tell us about yourself")
        }
        .photosPicker(isPresented: $viewModel.showingPhotoPicker, selection: $selectedPhoto)
        .onChange(of: selectedPhoto) { newValue in
            handlePhotoSelection(newValue)
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

private extension ProfileView {
    func handlePhotoSelection(_ newValue: PhotosPickerItem?) {
        if let newValue {
            Task {
                if let data = try? await newValue.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    selectedImage = image
                    viewModel.uploadPhoto(data: data)
                }
            }
            selectedPhoto = nil
        }
    }
}

#Preview {
    ProfileView()
}
