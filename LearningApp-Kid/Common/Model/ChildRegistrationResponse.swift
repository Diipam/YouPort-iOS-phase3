//
//  ChildRegistrationResponse.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 09/08/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import Foundation

struct ChildRegistrationResponse: Codable {
    let data: AllChilds
    let message: String
    let status: String
    let timestamp: Int
}



