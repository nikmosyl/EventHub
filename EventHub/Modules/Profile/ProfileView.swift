//
//  ProfileView.swift
//  EventHub
//
//  Created by Николай Игнатов on 13.09.2025.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    
    init(profile: ProfileModel) {
        _viewModel = StateObject(wrappedValue: ProfileViewModel(profile: profile))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                ProfileHeader(
                    avatarImage: selectedImage,
                    name: viewModel.profile.name,
                    isEditingMode: viewModel.isEditingMode,
                    onEditProfileTapped: viewModel.onEditProfileTapped,
                    onEditAvatarTapped: viewModel.onEditAvatarTapped,
                    onEditNameTapped: viewModel.onEditNameTapped
                )
                
                AboutSection(
                    aboutText: viewModel.profile.aboutMe,
                    isShowingFullText: viewModel.isShowingFullAbout,
                    isEditingMode: viewModel.isEditingMode,
                    onReadMoreTapped: viewModel.onReadMoreTapped,
                    onEditAboutTapped: viewModel.onEditAboutTapped
                )
                .padding(.horizontal, 20)
                
                Spacer()
                
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
            .padding(.top, 20)
            .padding(.bottom, 120)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Edit Name", isPresented: $viewModel.showingNameAlert) {
                TextField("Name", text: $viewModel.tempName)
                Button("Cancel", role: .cancel) { }
                Button("Save") {
                    viewModel.updateName()
                }
            } message: {
                Text("Enter your new name")
            }
            .alert("Edit About Me", isPresented: $viewModel.showingAboutAlert) {
                TextField("About Me", text: $viewModel.tempAboutMe, axis: .vertical)
                    .lineLimit(3...6)
                Button("Cancel", role: .cancel) { }
                Button("Save") {
                    viewModel.updateAbout()
                }
            } message: {
                Text("Tell us about yourself")
            }
            .photosPicker(isPresented: $viewModel.showingPhotoPicker, selection: $selectedPhoto)
            .onChange(of: selectedPhoto) { newValue in
                if let newValue = newValue {
                    Task {
                        if let data = try? await newValue.loadTransferable(type: Data.self) {
                            selectedImage = UIImage(data: data)
                        }
                    }
                    selectedPhoto = nil
                }
            }
        }
    }
}

#Preview {
    ProfileView(profile: .example)
}
