//
//  UpdateChildInfoResponse.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 16/08/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import Foundation

struct UpdateChildInfoResponse: Codable{
    let data: UpdateChildInfo
    let message: String
    let status: String
    let timestamp: Int
}

struct UpdateChildInfo: Codable {
    let age: String
    let dateofbirth: String
    let gender: String
    let image_path: String?
    let nickname: String
}

//let age: Int
//let created_on: String
//let dateofbirth: String
//let gender: String
//var id: Int
//let image_path: String?
//let nickname: String
//let problem_settings: [ProblemSettings]?
//let updated_on: String
