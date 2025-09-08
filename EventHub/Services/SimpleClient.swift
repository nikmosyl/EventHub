//
//  SimpleClient.swift
//  EventHub
//
//  Created by Наташа Спиридонова on 08.09.2025.
//


import Foundation

final class SimpleClient {
    private let baseURL = URL(string: "https://kudago.com/public-api/v1.4")!
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        self.decoder = decoder
    }

    func fetch<T: Decodable>(_ request: APIRequest) async throws -> T {
        let (data, response) = try await session.data(for: try request.urlRequest(baseURL: baseURL))
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw NetworkError.invalidResponse
        }
        return try decoder.decode(T.self, from: data)
    }
}
