//
//  CheckOrTerminateInitializeResponse.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 17/10/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import Foundation
struct CheckOrTerminateInitiliazeResponse: Codable {
	let data: CheckOrTerminateInitiliaze?
	let message, status: String?
	let timestamp: Int?
}

// MARK: - DataClass
struct CheckOrTerminateInitiliaze: Codable {
	let checked: [String]?
	let created_on: String?
	let current_state: [CurrentState]?
	let device_id: String?
	let history: [[CurrentState]]?
	let init_id, object_id, status, updated_on: String?
}

