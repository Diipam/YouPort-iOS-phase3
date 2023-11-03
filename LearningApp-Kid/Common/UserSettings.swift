//
//  UserSettings.swift
//  LearningApp-Kid
//
//  Created by Prakash Bist on 5/11/22.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import Foundation
import UIKit

enum UserSettings: String {

    case isChildRegistered
    case deviceId
    case access_token
    case refreshToken
	case accessTokenExpiration
 	case quizObjectId
	case quizProblemId
    case childInfo
    case contentType

    static func initialize() {
        UserDefaults.standard.register(defaults: [
            UserSettings.isChildRegistered.rawValue: false
        ])
    }

    func set(value: Any?) {
        switch self {
        case .isChildRegistered:
            if let value = value as? Bool {
                UserDefaults.standard.set(value, forKey: self.rawValue)
            }
        case .deviceId:
            if let value = value as? String {
                UserDefaults.standard.set(value, forKey: self.rawValue)
            }
        case .access_token:
            if let value = value as? String? {
                UserDefaults.standard.set(value, forKey: self.rawValue)
            }
        case .refreshToken:
            if let value = value as? String? {
                UserDefaults.standard.set(value, forKey: self.rawValue)
            }

		case .quizObjectId:
			if let value = value as? String? {
				UserDefaults.standard.set(value ?? nil, forKey: self.rawValue)
			}
		case .quizProblemId:
			if let value = value as? String? {
				UserDefaults.standard.set(value ?? nil, forKey: self.rawValue)
			}
//		case .lastBirthdayShownDates:
//			if let value = value as? [BirthdayNotification] {
//				let encoder = JSONEncoder()
//				if let encoded = try? encoder.encode(value) {
//					UserDefaults.standard.set(encoded, forKey: self.rawValue)
//				}
//			}
		case .accessTokenExpiration:
			if let value = value as? Date? {
				UserDefaults.standard.set(value, forKey: self.rawValue)
			}
        case .childInfo:
            if let value = value as? AllChilds {
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(value) {
                    UserDefaults.standard.set(encoded, forKey: self.rawValue)
                }
            }

        case .contentType:
            if let value = value as? String {
                UserDefaults.standard.set(value, forKey: self.rawValue)
            }
        }
	}

    func bool() -> Bool {
        return UserDefaults.standard.bool(forKey: self.rawValue)
    }

    func string() -> String? {
        return UserDefaults.standard.string(forKey: self.rawValue) ?? nil
    }

    func int() -> Int? {
        return UserDefaults.standard.integer(forKey: self.rawValue)
    }

	func double() -> Double? {
		return UserDefaults.standard.double(forKey: self.rawValue)
	}

    func clear(saved entity: UserSettings) {
        UserDefaults.standard.removeObject(forKey: entity.rawValue)
    }

	func date() -> Date? {
		if let data = UserDefaults.standard.object(forKey: self.rawValue) as? Data,
			let date = try? JSONDecoder().decode(Date.self, from: data) {
			return date
		}
		return nil
	}

    func childInfo() -> AllChilds? {
        if let data = UserDefaults.standard.data(forKey: self.rawValue), let decoded = try? JSONDecoder().decode(AllChilds.self, from: data) {
            return decoded
        }
        return nil
    }

//	func lastBirthdayShownDates() -> [BirthdayNotification] {
//		if let data = UserDefaults.standard.data(forKey: self.rawValue),
//		   let decoded = try? JSONDecoder().decode([BirthdayNotification].self, from: data) {
//			return decoded
//		}
//		return []
//	}
}

//struct BirthdayNotification: Codable {
//	let childId: Int
//	let shownDate: String
//}
