//
//  UpdateInitializeProblemGameResponse.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 20/09/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import Foundation

// MARK: - Empty
struct UpdateInitializerProblemGameResponse: Codable {
    let data: UpdateInitializeProblem?
    let message, status: String?
    let timestamp: Int?
}

// MARK: - DataClass
struct UpdateInitializeProblem: Codable {
    let checked: [String]?
    let created_on: String?
    let current_state: [CurrentState]?
    let device_id: String?
    let history: [[CurrentState]]?
    let init_id, object_id, status, updated_on: String?
}

// MARK: - CurrentState
struct CurrentState: Codable {
    let question_id: String?
}
