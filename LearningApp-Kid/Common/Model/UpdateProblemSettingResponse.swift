//
//  UpdateProblemSettingResponse.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 17/08/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import Foundation
struct UpdateProblemSettingResponse: Codable {
    let data: UpdateProblemSetting
    let message: String
    let status: String
    let timestamp: Int
    
}

struct UpdateProblemSetting: Codable {
    let answer_time: String
    let correct_answer_quota: String
    let problem_difficulty: String
    let question_frequency: String
}
