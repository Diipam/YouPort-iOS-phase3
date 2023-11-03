//
//  GetAllChildByIdResponse.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 19/08/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import Foundation

struct GetAllChildByIdResponse: Codable {
    let data: AllChilds
    let message: String
    let status: String
    let timestamp: Int
}
