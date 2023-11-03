//
//  String+Extension.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 05/08/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}

extension String{
    var asURL: URL? {
        return URL(string: self)
    }
}

