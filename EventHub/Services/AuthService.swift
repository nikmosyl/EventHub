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
import UIKit

struct UserModel: Codable {
    var uid: String
    var displayName: String
    var email: String
    var photoURL: String?
}

@MainActor
final class AuthService {
    static let shared = AuthService()
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
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
    
    func resetPassword(oldPassword: String, newPassword: String) {
        #warning("TO DO resetPassword")
    }
    
    var currentUser: User? {
        Auth.auth().currentUser
    }
    
    // MARK: - Firestore
    func saveUser(_ user: UserModel) async throws {
        try db.collection("users").document(user.uid).setData(from: user)
    }
    
    func getUser(uid: String) async throws -> UserModel {
        let snapshot = try await db.collection("users").document(uid).getDocument()
        return try snapshot.data(as: UserModel.self)
    }
    
    // MARK: - Storage
    func uploadPhoto(uid: String, image: UIImage) async throws -> String {
        let ref = storage.reference().child("profile_photos/\(uid).jpg")
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "ImageError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не удалось преобразовать UIImage"])
        }
        
        _ = try await ref.putDataAsync(data)
        return try await ref.downloadURL().absoluteString
    }
    
    // MARK: - Google Sign In
    func signInWithGoogle(presenting: UIViewController) async throws -> AuthDataResult {
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
}
