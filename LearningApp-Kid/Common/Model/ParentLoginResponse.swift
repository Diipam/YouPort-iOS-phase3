//
//  ParentLoginResponse.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 09/08/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import Foundation
// MARK: - Empty
struct ParentLoginResponse: Codable {
	let data: ParentLogin
	let message, status: String
	let timestamp: Int
}

// MARK: - DataClass
struct ParentLogin: Codable {
	let access_token: String
	let refresh_token: String
}
