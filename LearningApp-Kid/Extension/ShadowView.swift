//
//  ShadowView.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 14/10/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//


import Foundation
import UIKit

class ShadowView: UIView{
	override init(frame: CGRect) {
		super.init(frame: frame)
		initialSetUp()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		initialSetUp()
	}

	private func initialSetUp(){
		layer.shadowColor = UIColor.label.cgColor
		layer.shadowOffset = .zero
//		layer.cornerRadius = 10
		layer.shadowRadius = 5
		layer.shadowOpacity = 0.3

	}


}


