//
//  RefreshAccessTokenResponse.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 02/03/2023.
//  Copyright © 2023 SmartSolarNepal. All rights reserved.
//

import Foundation

// MARK: - Empty
struct RefreshAccessTokenResponse: Codable {
	let data: DataClass
	let message, status: String
	let timestamp: Int
}

// MARK: - DataClass
struct DataClass: Codable {
	let access_token: String
}
