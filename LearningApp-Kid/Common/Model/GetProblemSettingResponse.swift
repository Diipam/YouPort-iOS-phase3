//
//  GetProblemSettingResponse.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 16/08/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import Foundation
struct GetProblemSettingResponse: Codable {
    let data: [ProblemSettings]
    let message: String
    let status: String
    let timestamp: Int
}

//struct SavedProblemSetting: Codable {
//    let answer_time: Int
//    let child_id: Int
//    let correct_answer_quota: Int
//    let created_on: String
//    let id: Int
//    let problem_difficulty: Int
//    let question_frequency: Int
//    let status: String
//    let updated_on: String
//}

