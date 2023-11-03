//
//  deleteChidResponse.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 31/10/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import Foundation

struct DeleteChildResponse: Codable {
	let data: DeleteChild
	let message, status: String
	let timestamp: Int
}

// MARK: - DataClass
struct DeleteChild: Codable {
	let child_id: String
}
