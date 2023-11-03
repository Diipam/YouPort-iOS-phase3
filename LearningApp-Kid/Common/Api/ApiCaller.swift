//
//  AuthManager.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 09/08/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import Foundation
import UIKit

final class ApiCaller {
	static let shared = ApiCaller()
	private init() {}

	private let expirationTimeInSeconds: Double = 15

	private var accessToken: String? {
		return UserSettings.access_token.string()
	}

	private var refreshToken: String? {
		return UserSettings.refreshToken.string()
	}


	// MARK: - To Check if AccessToken is Expired or not -
	private func hasAccessTokenExpired() -> Bool {
		guard let expirationTime = UserSettings.accessTokenExpiration.date() else {
			return true
		}
		return Date() > expirationTime + 3
	}

	public func refreshAccessTokenIfNeeded(completion: @escaping (Result<Void, Error>) -> Void) {
		if hasAccessTokenExpired() {

			AuthManager.shared.refreshAccessToken { result in
				switch result {
				case .success(let success):
					UserSettings.access_token.set(value: success.data.access_token)
					let expirationTime = Date().addingTimeInterval(self.expirationTimeInSeconds)
					UserSettings.accessTokenExpiration.set(value: expirationTime)
					completion(.success(()))

				case .failure(let error):
					print(error.localizedDescription)
					completion(.failure(error))
				}
			}
		} else {
			completion(.success(()))
		}
	}


	// MARK: - End Check AccessToken has Expired or not -

	// MARK: - Delete Child -
	public func deleteChild(childId: Int, completion: @escaping(Result<DeleteChildResponse, Error>) -> Void) {
		refreshAccessTokenIfNeeded { result in
			switch result {
			case .success:
				guard let token = self.accessToken else { return }
				let urlString = Route.baseUrl + Route.deleteChild(childId).description
				guard let url = urlString.asURL else {
					print("this is not a valid url")
					return
				}
				var urlRequest = URLRequest(url: url)
				urlRequest.httpMethod = Method.delete.rawValue
				urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
				urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

				URLSession.shared.dataTask(with: urlRequest) { data, response, error in
					guard let data = data, error == nil else {
						completion(.failure(ApiError.networkError))
						return
					}
					do {
//						let result1 = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//						print(result1)
						let result = try JSONDecoder().decode(DeleteChildResponse.self, from: data)
						completion(.success(result))
					} catch let error {
						print(error)
						completion(.failure(ApiError.decodingError))
					}
				}.resume()

			case .failure(let error):
				completion(.failure(error))
			}
		}
	}

	// MARK: - End Delete Child -

	// MARK: - Check or Terminate game -

	public func checkOrTerminateGame(initId: String,isAnswerRight: Bool, terminateGame: Bool, completion: @escaping(Result<CheckOrTerminateInitiliazeResponse, Error>) -> Void){

		let params = ["isAnswerRight": isAnswerRight,"terminateGame": terminateGame]

		let urlString = Route.baseUrl + Route.checkOrTerminateGame(initId).description
		guard let url = urlString.asURL else {
			print("this is not a valid url")
			return
		}
		var urlRequest = URLRequest(url: url)

		refreshAccessTokenIfNeeded { result in
			switch result {
			case .success:
				guard let token = self.accessToken else { return }
				urlRequest.httpMethod = Method.put.rawValue
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
//						let result1 = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//						print(result1)
						let result = try JSONDecoder().decode(CheckOrTerminateInitiliazeResponse.self, from: data)
//						print(result)
						completion(.success(result))
					} catch let error {
						print(error)
						completion(.failure(ApiError.decodingError))
					}
				}.resume()

			case .failure(let error):
				completion(.failure(error))
			}
		}
	}


	// MARK: - End Check or Terminate Quiz -

	// MARK: - update Initialize Quiz -
	public func updateInitializeProblemGame(initId: String,questionId: String, append: Bool, completion: @escaping(Result<UpdateInitializerProblemGameResponse, Error>) -> Void){

		let params: [String: Any] = [
			"state":[
				"question_id": questionId
			],
			"append": append
		]

		refreshAccessTokenIfNeeded { result in
			switch result {
			case .success:
				guard let token = self.accessToken else { return }

				let urlString = Route.baseUrl + Route.updateInitializeProblemGame(initId).description
				guard let url = urlString.asURL else {
					print("this is not a valid url")
					return
				}
				var urlRequest = URLRequest(url: url)
				urlRequest.httpMethod = Method.put.rawValue

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
//						let result1 = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//						print(result1)
						let result = try JSONDecoder().decode(UpdateInitializerProblemGameResponse.self, from: data)
//						print(result)
						completion(.success(result))
					} catch let error {
						print(error)
						completion(.failure(ApiError.decodingError))
					}
				}.resume()

			case .failure(let error):
				completion(.failure(error))
			}
		}
	}

	// MARK: - End update Initialize -

	// MARK: - Initialize Quiz -
	public func initializeProblemGame(objectId: String, deviceIdWithChildId: String, completion: @escaping(Result<InitializeProblemGameResponse, Error>) -> Void){
		let params = ["device_id": deviceIdWithChildId]
		let urlString = Route.baseUrl + Route.initializeProblemGame(objectId).description
		guard let url = urlString.asURL else {
			print("this is not a valid url")
			return
		}

		refreshAccessTokenIfNeeded { result in
				switch result {
				case .success:
					guard let token = self.accessToken else { return }

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
	//						let result1 = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
	//						print(result1)
							let result = try JSONDecoder().decode(InitializeProblemGameResponse.self, from: data)
	//						print(result)
							completion(.success(result))
						} catch let error {
							print(error)
							completion(.failure(ApiError.decodingError))
						}
					}.resume()

				case .failure(let error):
					completion(.failure(error))
				}
			}
		}

	// MARK: - End Initialize Quiz -

	// MARK: - get all Quiz Questions -
	public func getAllProblemQuestions(problemDifficulty: String, objectId: String?, problemId: String? ,completion: @escaping(Result<AllQuestionResponse, Error>) -> Void) {
		var params = [String: Any]()

		if let objectId = objectId, let problemId = problemId {
			params = [
				"problem_difficulty": problemDifficulty,
				"lastEvaluatedKey": [
					"object_id": objectId,
					"problem_id": problemId
				]
			]
		} else {
			params = ["problem_difficulty": problemDifficulty]
		}
		print(params)

		let urlString = Route.baseUrl + Route.getAllQuestions.description
		guard let url = urlString.asURL else {
			print("this is not a valid url")
			return
		}

		refreshAccessTokenIfNeeded { result in
			switch result {
			case .success:
				guard let token = self.accessToken else { return }

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
//						let result1 = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//						print(result1)
						let result = try JSONDecoder().decode(AllQuestionResponse.self, from: data)
//						print(result)
						completion(.success(result))
					} catch let error {
						print(error)
						completion(.failure(ApiError.decodingError))
					}
				}.resume()

			case .failure(let error):
				completion(.failure(error))
			}
		}
	}

	// MARK: - End Get All Quiz Questions -

	// MARK:  Api call to refresh the token
	public func refreshAccessToken(completion: @escaping(Result<RefreshAccessTokenResponse, Error>) -> Void){
		guard let token = refreshToken else { return }
		let deviceId = UserSettings.deviceId.string()
		let params = ["device_id": deviceId]
		let urlString = Route.baseUrl + Route.refreshAccessToken.description

		guard let url = urlString.asURL else {
			print("this is not a valid url")
			return
		}
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = "POST"
		urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
		urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

		let bodyData = try? JSONSerialization.data(withJSONObject: params, options: [])
		urlRequest.httpBody = bodyData

		URLSession.shared.dataTask(with: urlRequest) { data, response, error in
			guard let data = data, error == nil else {
				completion(.failure(ApiError.decodingError))
				return
			}
			do {
//                let result1 = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//                print(result1)
				let result = try JSONDecoder().decode(RefreshAccessTokenResponse.self, from: data)
//				print(result)
				completion(.success(result))
			} catch {
				print("The error is \(error.localizedDescription)")
				completion(.failure(error))

			}

		}.resume()

	}


	// MARK: - Get all child by ID -
	public func getAllChildById(childId: Int, completion: @escaping(Result<GetAllChildByIdResponse, Error>) -> Void){
		let urlString = Route.baseUrl + Route.getAllChildById(childId).description

		guard let url = urlString.asURL else {
			print("this is not a valid url")
			return
		}

		refreshAccessTokenIfNeeded { result in
			switch result {
			case .success:
				guard let token = self.accessToken else { return }

				var urlRequest = URLRequest(url: url)
				urlRequest.httpMethod = Method.get.rawValue
				urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
				urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

				URLSession.shared.dataTask(with: urlRequest) { data, response, error in
					guard let data = data, error == nil else {
						completion(.failure(ApiError.networkError))
						return
					}
					do {
//												let result1 = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//												print(result1)
						let result = try JSONDecoder().decode(GetAllChildByIdResponse.self, from: data)
//												print(result)
						completion(.success(result))
					} catch let error {
						print(error)
						completion(.failure(ApiError.decodingError))
					}
				}.resume()

			case .failure(let error):
				completion(.failure(error))
			}
		}
	}

	// MARK: - End Get All Child by ID  -

	// MARK: - Update Problem Setting of Child -
	public func updateProblemSetting(childId: Int,id: Int, questionFrequency: String, answerTime: String, problemDifficulty: String, correctAnswerQuota: String, completion: @escaping(Result<UpdateProblemSettingResponse, Error>) -> Void){

		let params = ["question_frequency": questionFrequency, "answer_time": answerTime, "problem_difficulty": problemDifficulty, "correct_answer_quota": correctAnswerQuota]

		let urlString = Route.baseUrl + Route.updateProblemSettingOfChild(childId, id).description
		guard let url = urlString.asURL else {
			print("this is not a valid url")
			return
		}

		refreshAccessTokenIfNeeded { result in
			switch result {
			case .success:
				guard let token = self.accessToken else { return }

				var urlRequest = URLRequest(url: url)
				urlRequest.httpMethod = Method.put.rawValue
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
						let result1 = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
						print(result1)
						let result = try JSONDecoder().decode(UpdateProblemSettingResponse.self, from: data)
						print(result)
						completion(.success(result))
					} catch let error {
						print(error)
						completion(.failure(ApiError.decodingError))
					}
				}.resume()

			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
	// MARK: - End update problem setting -

	// MARK: - Get all Problem Setting -
	public func getAllProblemSetting(childId: Int, completion: @escaping(Result<GetProblemSettingResponse, Error>) -> Void){
		refreshAccessToken { result in
			switch result {
			case .success(let success):
				UserSettings.access_token.set(value: success.data.access_token)

			case .failure(let error):
				print(error.localizedDescription)
			}
		}

		guard let token = accessToken else { return }
		let deviceId = UserSettings.deviceId.string()
		let params = ["device_id": deviceId]
		let urlString = Route.baseUrl + Route.getProblemSettingOfChild(childId).description

		guard let url = urlString.asURL else {
			print("this is not a valid url")
			return
		}
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = "GET"
		urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
		urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

		var urlComponent = URLComponents(string: urlString)
		urlComponent?.queryItems = params.map {
			URLQueryItem(name: $0, value: "\(String(describing: $1))")
		}

		urlRequest.url = urlComponent?.url
		URLSession.shared.dataTask(with: urlRequest) { data, response, error in
			guard let data = data, error == nil else {
				completion(.failure(ApiError.decodingError))
				return
			}
			do {
//                let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//                print(result)
				let result = try JSONDecoder().decode(GetProblemSettingResponse.self, from: data)
				completion(.success(result))
			} catch {
				print("The error is \(error.localizedDescription)")
				completion(.failure(error))

			}

		}.resume()

	}

// MARK:  update child
	public func updateChildInfo(id: Int, gender: String, nickname: String,dateofbirth: String, age: String, image: UIImage, completion: @escaping(Result<UpdateChildInfoResponse, Error>) -> Void){
		refreshAccessToken { result in
			switch result {
			case .success(let success):
				UserSettings.access_token.set(value: success.data.access_token)

			case .failure(let error):
				print(error.localizedDescription)
			}
		}

		let formFields = ["gender": gender, "nickname": nickname, "dateofbirth": dateofbirth, "age": age]
		let image_data = image.jpegData(compressionQuality: 0.9)
		guard let image_data = image_data else { return }
		guard let token = accessToken else { return }

		let boundary = "Boundary-\(UUID().uuidString)"
		let urlString = Route.baseUrl + Route.updateChild(id).description

		guard let url = urlString.asURL else {
			print("this is not a valid url")
			return
		}

		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = "PUT"
		urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
		urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

		let httpBody = NSMutableData()

		for (key, value) in formFields {
		  httpBody.appendString(convertFormField(named: key, value: value, using: boundary))
		}

		httpBody.append(convertFileData(fieldName: "image",
										fileName: "image.jpg",
										mimeType: "image/jpg",
										fileData: image_data,
										using: boundary))

		httpBody.appendString("--\(boundary)--")

		urlRequest.httpBody = httpBody as Data

		URLSession.shared.dataTask(with: urlRequest) { data, response, error in
			guard let data = data, error == nil else {
				completion(.failure(ApiError.decodingError))
				return
			}
			do {
//                let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//                                  print(result)
				let result = try JSONDecoder().decode(UpdateChildInfoResponse.self, from: data)
				completion(.success(result))
			} catch {
				print("The error is \(error.localizedDescription)")
				completion(.failure(error))

			}

		}.resume()
		}

	// MARK:  Save Problem Settings
	public func saveProblemSetting(childId: Int, questionFrequency: String, answerTime: String, problemDifficulty: String, correctAnswerQuota: String, completion: @escaping(Result<ProblemSettingResponse, Error>) -> Void){

		refreshAccessToken { result in
			switch result {
			case .success(let success):
				UserSettings.access_token.set(value: success.data.access_token)

			case .failure(let error):
				print(error.localizedDescription)
			}
		}

		let params = ["question_frequency": questionFrequency, "answer_time": answerTime, "problem_difficulty": problemDifficulty, "correct_answer_quota": correctAnswerQuota]

		guard let token = accessToken else { return }
		let urlString = Route.baseUrl + Route.saveProblemSetting(childId).description
		guard let url = urlString.asURL else {
			print("this is not a valid url")
			return
		}
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = "POST"
		urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
		urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

		let bodyData = try? JSONSerialization.data(withJSONObject: params, options: [])
		urlRequest.httpBody = bodyData

		URLSession.shared.dataTask(with: urlRequest) { data, response, error in
			guard let data = data, error == nil else {
				completion(.failure(ApiError.decodingError))
				return
			}
			do {
//                 let result1 = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//                    print(result1)
				let result = try JSONDecoder().decode(ProblemSettingResponse.self, from: data)
				completion(.success(result))
			} catch {
				print("The error is \(error.localizedDescription)")
				completion(.failure(error))

			}

		}.resume()

	}

	// MARK:  Get all Child
	public func getAllChild(completion: @escaping(Result<getAllChildsResponse, Error>) -> Void){
		refreshAccessToken { result in
			switch result {
			case .success(let success):
//				print(success)
				UserSettings.access_token.set(value: success.data.access_token)

			case .failure(let error):
				print(error)
			}
		}

		guard let token = accessToken else { return }
		let urlString = Route.baseUrl + Route.getAllChilds.description

		guard let url = urlString.asURL else {
			print("this is not a valid url")
			return
		}
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = "GET"
		urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
		urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

		URLSession.shared.dataTask(with: urlRequest) { data, response, error in
			guard let data = data, error == nil else {
				completion(.failure(ApiError.decodingError))
				return
			}
			do {
//				let result1 = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//			                      print(result1)
				let result = try JSONDecoder().decode(getAllChildsResponse.self, from: data)
				completion(.success(result))
			} catch {
				print("The error is \(error)")
				completion(.failure(error))

			}

		}.resume()

	}



//     MARK:  save Child Info
	public func saveChildInfo(gender: String, nickname: String,dateofbirth: String, age: String, image: UIImage, completion: @escaping(Result<ChildRegistrationResponse, Error>) -> Void){
		refreshAccessToken { result in
			switch result {
			case .success(let success):
//				print(success)
				UserSettings.access_token.set(value: success.data.access_token)

			case .failure(let error):
				print(error.localizedDescription)
			}
		}

			let formFields = ["gender": gender, "nickname": nickname, "dateofbirth": dateofbirth, "age": age]

		guard let  image_data = image.jpegData(compressionQuality: 0.7) else{ return }

		guard let token = accessToken else { return }

			let boundary = "Boundary-\(UUID().uuidString)"
		let urlString = Route.baseUrl + Route.saveChildInfo.description
		guard let url = urlString.asURL else {
			print("this is not a valid url")
			return
		}
			var request = URLRequest(url: url)
			request.httpMethod = "POST"
			request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
			request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

			let httpBody = NSMutableData()

			for (key, value) in formFields {
			  httpBody.appendString(convertFormField(named: key, value: value, using: boundary))
			}

			httpBody.append(convertFileData(fieldName: "image",
											fileName: "someimage.jpg",
											mimeType: "image/jpeg",
											fileData: image_data,
											using: boundary))

			httpBody.appendString("--\(boundary)--")

			request.httpBody = httpBody as Data


			URLSession.shared.dataTask(with: request) { data, response, error in
				guard let data = data, error == nil else {
					completion(.failure(ApiError.decodingError))
					return
				}
				do {
//					let result1 = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//				                      print(result1)
					let result = try JSONDecoder().decode(ChildRegistrationResponse.self, from: data)
					completion(.success(result))
				} catch {
					print("The error is \(error.localizedDescription)")
					completion(.failure(error))

				}

			}.resume()
		}


	// MARK:  helping functions
	   func convertFormField(named name: String, value: String, using boundary: String) -> String {
		 var fieldString = "--\(boundary)\r\n"
		 fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
		 fieldString += "\r\n"
		 fieldString += "\(value)\r\n"

		 return fieldString
	   }

	   func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
		   let data = NSMutableData()

			 data.appendString("--\(boundary)\r\n")
			 data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
			 data.appendString("Content-Type: \(mimeType)\r\n\r\n")
			 data.append(fileData)
			 data.appendString("\r\n")

			 return data as Data
	   }
}

extension NSMutableData {
  func appendString(_ string: String) {
	if let data = string.data(using: .utf8) {
	  self.append(data)
	}
  }
}

