//
//  Route.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 09/08/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import Foundation

enum Route{
//    static let baseUrl = "http://ec2-54-147-254-178.compute-1.amazonaws.com/"
    static let baseUrl = "https://q30rci0cmk.execute-api.us-east-1.amazonaws.com/dev/"

    
    case registerParent
    case parentLogin
    case saveChildInfo
    case getAllChilds
    case saveProblemSetting(Int)
    case updateChild(Int)
    case getProblemSettingOfChild(Int)
    case updateProblemSettingOfChild(Int, Int)
    case getAllChildById(Int)
    case refreshAccessToken
    case getAllQuestions
    case initializeProblemGame(String)
    case updateInitializeProblemGame(String)
	case checkOrTerminateGame(String)
	case deleteChild(Int)
    
     var description: String{
        switch self {
        
        case .registerParent:
            return "/api/auth/register"
            
        case .parentLogin:
            return "/api/auth/login"
            
        case .saveChildInfo:
            return "/api/users/childs"
            
        case .getAllChilds:
            return "/api/users/childs"
            
        case .saveProblemSetting(let id):
            return "/api/users/childs/\(id)/problem-settings"
            
        case .updateChild(let id):
            return "/api/users/childs/\(id)"
            
        case .getProblemSettingOfChild(let id):
            return "/api/users/childs/\(id)/problem-settings"
            
        case .updateProblemSettingOfChild(let childId, let id):
            return "/api/users/childs/\(childId)/problem-settings/\(id)"
            
        case .getAllChildById(let id):
            return "/api/users/childs/\(id)"
            
        case .refreshAccessToken:
            return "/api/auth/refresh"
            
        case .getAllQuestions:
            return "/api/qus/problems/objects"
            
        case .initializeProblemGame(let obj_id):
            return "/api/qus/problems/\(obj_id)/initialize"
            
        case .updateInitializeProblemGame(let initId):
            return "/api/qus/problems/\(initId)/history"
			
		case .checkOrTerminateGame(let initId):
			return "/api/qus/problems/\(initId)"
			
		case .deleteChild(let childId):
			return "/api/users/childs/\(childId)"
		}
    }
}
