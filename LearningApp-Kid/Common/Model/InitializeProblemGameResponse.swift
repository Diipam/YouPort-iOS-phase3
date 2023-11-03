//
//  InitializeProblemGameResponse.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 15/09/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import Foundation
struct InitializeProblemGameResponse: Codable {
    let data: InitializeProblemGameData?
    let message, status: String?
    let timestamp: Int?
}

// MARK:  Data

struct InitializeProblemGameData: Codable {
    let answers: [Answer]?
    let created_on: String
    let device_id: String?
    let init_id, object_id: String?
    let questions: [QuestionsInitialized]?
    let status: String?
    let target: [Target]
    let updated_on: String?
    
}

struct QuestionsInitialized: Codable {
	let question: String?
	let question_id: String?
}
