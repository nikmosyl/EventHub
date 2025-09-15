//
//  DataManager.swift
//  EventHub
//
//  Created by Наташа Спиридонова on 08.09.2025.
//

import Foundation

enum UserSettingsLink: String {
    case onboarding
}
final class DataManager {
    static let shared = DataManager()
    
    private var rootViewModel: RootViewModel?
    
    private init() {}
    
    func setRootViewModel(_ viewModel: RootViewModel) {
        if rootViewModel == nil {
            rootViewModel = viewModel
        }
    }
    
    // MARK: - Универсальный запрос
    private func fetch<T: Decodable>(_ request: APIRequest) async throws -> T {
        
        #warning("убрать Debug")
        print("request.urlRequest():", try request.urlRequest())
        
        let (data, response) = try await URLSession.shared.data(for: try request.urlRequest())
        
        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(http.statusCode) else {
            throw NetworkError.badStatus(http.statusCode)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decoding(error)
        }
    }
    
    // MARK: - Универсальные методы
    private func fetchPaged<T: Decodable>(_ request: APIRequest) async throws -> [T] {
        let response: PagedResponse<T> = try await fetch(request)
        return response.results
    }
    
    private func fetchSimple<T: Decodable>(_ request: APIRequest) async throws -> T {
        return try await fetch(request)
    }
    
    // MARK: - Получение категорий событий
    private func fetchEventCategories() async throws -> [EventCategory] {
        try await fetchSimple(.eventCategories)
    }
    
    // MARK: - Получение событий с фильтрами
    private func fetchEvents(filters: EventFilters = EventFilters(), id: Int? = nil) async throws -> [Event] {
        let updatedFilters = EventFilters(
            location: filters.location,
            actualSince: filters.actualSince,
            actualUntil: filters.actualUntil,
            categories: filters.categories,
            search: filters.search,
            page: filters.page,
            price: filters.price,
            fields: filters.fields ?? [
                "id",
                "title",
                "slug",
                "description",
                "short_title",
                "dates",
                "location",
                "images",
                "categories",
                "favorites_count",
                "place"
            ],
            expand: filters.expand ?? [
                "place"
            ]
        )
        return try await fetchPaged(.events(filters: updatedFilters, id: id))
    }
    
    // MARK: - Получение одного события по ID
    private func fetchEvent(id: Int) async throws -> Event {
        let events = try await fetchEvents(id: id)
        guard let event = events.first else {
            throw NetworkError.invalidResponse
        }
        return event
    }
    
    // MARK: - Получение подборок
    private func fetchLists(page: Int? = nil) async throws -> [ListItem] {
        try await fetchPaged(.lists(page: page))
    }
    
    // MARK: - Получение локаций
    private func fetchLocations() async throws -> [Location] {
        try await fetchSimple(.locations)
    }
    
    // MARK: - Получение фильмов
    private func fetchMovies(page: Int? = nil) async throws -> [Movie] {
        try await fetchPaged(.movies(page: page))
    }
    
    
    // MARK: - Простое получение данных
    func searchEvents(query: String, location: String? = nil, page: Int? = nil) async throws -> [Event] {
        let filters = EventFilters(
            location: location,
            search: query,
            page: page
        )
        return try await fetchEvents(filters: filters)
    }
    
    func getUpcamingEvents(categories: [String]? = nil) async throws -> [Event] {
        let actualSince = Int(Date().timeIntervalSince1970)
        let actualUntil = actualSince + (7 * 24 * 60 * 60)
        
        let filters = EventFilters(
            actualSince: actualSince,
            actualUntil: actualUntil,
            categories: categories
        )
        return try await fetchEvents(filters: filters)
    }
    
    func getNearByEvents(location: String, categories: [String]? = nil) async throws -> [Event] {
        let filters = EventFilters(
            location: location,
            categories: categories
        )
        return try await fetchEvents(filters: filters)
    }
    
    func getCategories() async throws -> [EventCategory] {
        try await fetchEventCategories()
    }
    
    func getLocations() async throws -> [Location] {
        try await fetchLocations()
    }
    
    // MARK: - авторизация пользователя
    func loginUserWithGoogle(rememberUser: Bool) async throws {
        try await AuthService.shared.loginWithGoogle()
        
        guard let user = await AuthService.shared.currentUser else {
            throw NSError(
                domain: "DataManager",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Не удалось получить текущего пользователя"]
            )
        }
        
        let uid = user.uid
        let email = user.email ?? "empty"
        let displayName = user.displayName ?? "User"
        let photoURL = user.photoURL?.absoluteString ?? "empty"
        let bio = "empty"
        
        do {
            _ = try await AuthService.shared.getUser(uid: uid)
        } catch {
            let newUser = UserModel(
                uid: uid,
                displayName: displayName,
                email: email,
                photoURL: photoURL,
                bio: bio
            )
            try await AuthService.shared.saveUser(newUser)
        }
        
        if rememberUser {
            UserDefaults.standard.set(true, forKey: "rememberUser")
        } else {
            UserDefaults.standard.removeObject(forKey: "rememberUser")
        }
        
        await rootViewModel?.login()
    }

    
    func loginUser(email: String, password: String, rememberUser: Bool) async throws {
        let result = try await AuthService.shared.login(email: email, password: password)
        
        if rememberUser {
            UserDefaults.standard.set(true, forKey: "rememberUser")
        } else {
            UserDefaults.standard.removeObject(forKey: "rememberUser")
        }
        
        await rootViewModel?.login()
    }
    
    // MARK: - регистрация пользователя
    func registerUser(email: String, password: String, fullName: String) async throws {
        let result = try await AuthService.shared.register(
            email: email,
            password: password
        )
        let uid = result.user.uid
        
        let user = UserModel(
            uid: uid,
            displayName: fullName,
            email: email,
            photoURL: "empty",
            bio: "empty"
        )
        try await AuthService.shared.saveUser(user)
        
        await rootViewModel?.login()
    }
    
    // MARK: - восстановление пароля пользователя
    func resetUserPassword(email: String) async throws {
        try await AuthService.shared.forgotPassword(email: email)
    }
    
    // MARK: - изменение пароля
    func changeUserPassword(oldPassword: String, newPassword: String) async throws {
        try await AuthService.shared.changePassword(
            oldPassword: oldPassword,
            newPassword: newPassword
        )
    }
    
    // MARK: - получение данных пользователя
    func getUserData() async throws -> UserModel {
        guard let uid = await AuthService.shared.currentUser?.uid else {
            throw NSError(
                domain: "DataManager",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Пользователь не авторизован"]
            )
        }
        
        return try await AuthService.shared.getUser(uid: uid)
    }
    
    // MARK: - загрузка фотографии пользователя
    func uploadUserPhoto(data: Data) async throws {
        guard let uid = await AuthService.shared.currentUser?.uid else {
            throw NSError(
                domain: "DataManager",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Пользователь не авторизован"]
            )
        }
        
        let url = try await AuthService.shared.uploadPhoto(
            uid: uid,
            data: data,
            fileExtension: "jpg"
        )
        
        try await AuthService.shared.updateUser(uid: uid, photoURL: url)
    }
    
    // MARK: - обновление данных пользователя
    func updateUserData(
        photoURL: String? = nil,
        displayName: String? = nil,
        bio: String? = nil,
        userModel: UserModel? = nil
    ) async throws {
        guard let uid = await AuthService.shared.currentUser?.uid else {
            throw NSError(
                domain: "DataManager",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Пользователь не авторизован"]
            )
        }
        
        if let photoURL {
            try await AuthService.shared.updateUser(uid: uid, photoURL: photoURL)
        }
        if let displayName {
            try await AuthService.shared.updateUser(uid: uid, displayName: displayName)
        }
        if let bio {
            try await AuthService.shared.updateUser(uid: uid, bio: bio)
        }
        if let userModel {
            try await AuthService.shared.updateUser(uid: uid, photoURL: userModel.photoURL)
            try await AuthService.shared.updateUser(uid: uid, displayName: userModel.displayName)
            try await AuthService.shared.updateUser(uid: uid, bio: userModel.bio)
        }
    }
    
    // MARK: - выход (разлогинивание) пользователя
    @MainActor
    func logoutUser() throws {
        try AuthService.shared.logout()
        rootViewModel?.logout()
    }
    
    // MARK: - Onboarding
    @MainActor
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: UserSettingsLink.onboarding.rawValue)
        rootViewModel?.completeOnboarding()
    }
    
    func isOnboardingComplete() -> Bool {
        UserDefaults.standard.bool(forKey: UserSettingsLink.onboarding.rawValue)
    }
}
