//
//  ApiError.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 09/08/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//


import Foundation

enum ApiError: LocalizedError {
	case networkError
	case decodingError
	case serverError(String)
	case internetError
	case invalidUrl
	case wrongPassword

	var errorDescription: String? {
		switch self {
		case .networkError, .internetError:
			return "There was a problem connecting to the server. Please check your internet connection and try again.".localized()
		case .decodingError:
			return "There was a problem decoding the server response.".localized()
		case .serverError(let message):
			return message
		case .invalidUrl:
			return "The URL is invalid."
		case .wrongPassword:
			return "Incorrect Password.".localized()
		}
	}
}

