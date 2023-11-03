//
//  SaveProblemSettingResponse.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 11/08/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import Foundation

struct ProblemSettingResponse: Codable {
    var data: ProblemSettings
    let message, status: String
    let timestamp: Int
}

struct ProblemSettings: Codable {
    let answer_time, child_id, correct_answer_quota: Int
    let created_on: String
    let id, question_frequency: Int
    let status, updated_on: String
	var problem_difficulty : Int
}
