//
//  ApiCaller.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 09/08/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import Foundation

final class AuthManager {
	static let shared = AuthManager()

	private init() { }

	// MARK: - Register Parent -
	public func registerParent(deviceId: String, password: String, appversion: String,completion: @escaping(Result<parentRegistrationResponse, Error>) -> Void){
		let urlString = Route.baseUrl + Route.registerParent.description
		let params = ["device_id": deviceId, "password": password, "app_version": appversion]

		guard let url = URL(string: urlString) else {
			completion(.failure(ApiError.invalidUrl))
			return
		}

		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = Method.post.rawValue
		urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

		let bodyData = try? JSONSerialization.data(withJSONObject: params, options: [])
		urlRequest.httpBody = bodyData

		URLSession.shared.dataTask(with: urlRequest) { data, response, error in
			guard let data = data, error == nil else {
				completion(.failure(ApiError.networkError))
				return
			}
			do {
				//				let result1 = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
				//				print(result1)
				let result = try JSONDecoder().decode(parentRegistrationResponse.self, from: data)
				completion(.success(result))
			} catch let error {
				print(error)
				completion(.failure(ApiError.decodingError))
			}
		}.resume()
	}


	// MARK: - parent login  -
	public func parentLogin(deviceId: String, password: String, completion: @escaping(Result<ParentLoginResponse, Error>) -> Void){
		let params = ["device_id": deviceId, "password": password]

		let urlString = Route.baseUrl + Route.parentLogin.description

		guard let url = URL(string: urlString) else {
			completion(.failure(ApiError.invalidUrl))
			return
		}

		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = Method.post.rawValue
		urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

		let bodyData = try? JSONSerialization.data(withJSONObject: params, options: [])
		urlRequest.httpBody = bodyData

		URLSession.shared.dataTask(with: urlRequest) { data, response, error in
			guard let data = data, error == nil else {
				completion(.failure(ApiError.networkError))
				return
			}
			do {
				//				let result1 = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
				//				print(result1)
				let result = try JSONDecoder().decode(ParentLoginResponse.self, from: data)
				completion(.success(result))
			} catch let error {
				print(error)
				completion(.failure(ApiError.wrongPassword))
			}
		}.resume()
	}


	// MARK: - Refresh Token -
	public func refreshAccessToken(completion: @escaping(Result<RefreshAccessTokenResponse, Error>) -> Void){
		guard let token = UserSettings.refreshToken.string() else { return }
		let deviceId = UserSettings.deviceId.string()
		let params = ["device_id": deviceId]
		let urlString = Route.baseUrl + Route.refreshAccessToken.description

		guard let url = urlString.asURL else {
			completion(.failure(ApiError.invalidUrl))
			return
		}
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = Method.post.rawValue
		urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
		urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

		let bodyData = try? JSONSerialization.data(withJSONObject: params, options: [])
		urlRequest.httpBody = bodyData

		URLSession.shared.dataTask(with: urlRequest) { data, response, error in
			guard let data = data, error == nil else {
				completion(.failure(ApiError.networkError))
				return
			}
			do {
//								let result1 = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//								print(result1)
				let result = try JSONDecoder().decode(RefreshAccessTokenResponse.self, from: data)
				UserSettings.access_token.set(value: result.data.access_token)
				UserSettings.accessTokenExpiration.set(value: Date().addingTimeInterval(15))
				completion(.success(result))
			} catch let error {
				print(error)
//				completion(.failure(ApiError.wrongPassword))
			}
		}.resume()

	}

}

