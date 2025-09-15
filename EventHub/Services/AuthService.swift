//
//  AuthService.swift
//  EventHub
//
//  Created by nikita on 07.09.2025.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import GoogleSignIn

struct UserModel: Codable {
    var uid: String
    var displayName: String
    var email: String
    var photoURL: String
    var bio: String
}

@MainActor
final class AuthService {
    static let shared = AuthService()
    
    private let database = Firestore.firestore()
    private let storage = Storage.storage()
    
    var currentUser: User? {
        Auth.auth().currentUser
    }
    
    private init() {}
    
    // MARK: - Auth
    func register(email: String, password: String) async throws -> AuthDataResult {
        try await Auth.auth().createUser(withEmail: email, password: password)
    }
    
    func login(email: String, password: String) async throws -> AuthDataResult {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    func logout() throws {
        try Auth.auth().signOut()
    }
    
    func forgotPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func changePassword(oldPassword: String, newPassword: String) async throws {
        guard let user = Auth.auth().currentUser,
              let email = user.email else {
            throw NSError(
                domain: "AuthService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Пользователь не авторизован"]
            )
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: oldPassword)
        try await user.reauthenticate(with: credential)
        try await user.updatePassword(to: newPassword)
    }
    
    
    // MARK: - Firestore
    func saveUser(_ user: UserModel) async throws {
        try database.collection("users").document(user.uid).setData(from: user)
    }
    
    func getUser(uid: String) async throws -> UserModel {
        let snapshot = try await database.collection("users").document(uid).getDocument()
        return try snapshot.data(as: UserModel.self)
    }

    func updateUser(uid: String, photoURL: String) async throws {
        try await database.collection("users").document(uid).updateData([
            "photoURL": photoURL
            ])
    }
    
    func updateUser(uid: String, displayName: String) async throws {
        try await database.collection("users").document(uid).updateData([
            "displayName": displayName
            ])
    }
    
    func updateUser(uid: String, bio: String) async throws {
        try await database.collection("users").document(uid).updateData([
            "bio": bio
            ])
    }
    
    // MARK: - Storage
    func uploadPhoto(uid: String, data: Data, fileExtension: String = "jpg") async throws -> String {
        let ref = storage.reference().child("profile_photos/\(uid).\(fileExtension)")
        
        _ = try await ref.putDataAsync(data)
        return try await ref.downloadURL().absoluteString
    }
    
    // MARK: - Google Sign In
    private func signInWithGoogle(presenting: UIViewController) async throws -> AuthDataResult {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw NSError(domain: "GoogleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "Отсутствует clientID"])
        }
        
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: presenting)
        
        guard let idToken = result.user.idToken else {
            throw NSError(domain: "GoogleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "Нет idToken"])
        }
        
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken.tokenString,
            accessToken: result.user.accessToken.tokenString
        )
        
        return try await Auth.auth().signIn(with: credential)
    }
    
    func loginWithGoogle() async throws {
        guard let rootVC = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow?.rootViewController })
            .first else { return }
        
        let result = try await AuthService.shared.signInWithGoogle(presenting: rootVC)
        
        print("--> Google Signed In: \(result.user.uid)")
    }
}
