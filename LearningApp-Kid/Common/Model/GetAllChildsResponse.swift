//
//  GetAllChildsResponse.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 10/08/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import Foundation

struct getAllChildsResponse: Codable {
    let data: [AllChilds]?
    let message: String
    let status: String
    let timestamp: Int
}

struct AllChilds: Codable {
    var age: Int
    let created_on: String
    let dateofbirth: String
    let gender: String
    var id: Int
    let image_path: String?
    let nickname: String
    var problem_settings: [ProblemSettings]?
    let updated_on: String
    
}

