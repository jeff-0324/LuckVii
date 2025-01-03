//
//  MovieManager.swift
//  LuckVii
//
//  Created by 박진홍 on 12/17/24.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private let successRange: Range = (200..<300)
    private let apiKey: String = "b73e6f73276501cdee3491a188cf2e93"// api 요청 키(진홍 거)
    private let baseURL: String = "https://api.themoviedb.org/3/movie"// 기본 url

    private init() {} // single ton 객체

    // MARK: - fetch method

    func fetchData<T: Decodable>(
        endpoint: URLEndpointSet,
        parameters: URLParameters
    ) async throws -> T {
        guard let url = buildURL(endpoint: endpoint.rawValue, parameters: parameters) else {// URL생성
            throw AppError.networkError(.invalidURL)
        }

        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))

        guard let response = response as? HTTPURLResponse,
              successRange.contains(response.statusCode) else {
            throw AppError.networkError(.invalidResponse)
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw AppError.networkError(.decodingError)
        }
    }

    // MARK: - Helper 메서드

    private func buildURL(endpoint: String, parameters: URLParameters) -> URL? {

        var components: URLComponents? = URLComponents(string: baseURL + endpoint)
        var queryItems: [URLQueryItem] = [URLQueryItem(name: "api_key", value: apiKey)]// apikey를 가진 쿼리 아이템 배열 생성

        parameters.forEach { key, value in// apikey외에 필요한 파라미터들 추가
            queryItems.append(URLQueryItem(name: key, value: value))
        }

        components?.queryItems = queryItems// 컴포넌츠에 쿼리아이템 입력
        return components?.url// 만들어진 url 반환
    }
}
