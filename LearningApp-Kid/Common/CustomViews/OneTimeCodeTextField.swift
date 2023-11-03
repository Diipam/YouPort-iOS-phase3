//
//  OneTimeCodeTextField.swift
//  LearningApp-Kid
//
//  Created by Anisha Lamichhane on 08/08/2022.
//  Copyright © 2022 SmartSolarNepal. All rights reserved.
//

import Foundation
import UIKit
class OneTimeCodeTextfield: UITextField {
    var didEnterLastDigit: ((String) -> Void)?
    var defaultCharacter = "__"
    private var isErrorState = false

    
    private var isConfigured  = false
    private var digitLabels = [UILabel]()

    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
		recognizer.numberOfTouchesRequired = 1
        recognizer.addTarget(self, action: #selector(becomeFirstResponder))
        return recognizer
    }()
    
    func configure(with slotCount: Int = 4){
        guard isConfigured == false else { return }
        isConfigured.toggle()
        configureTextfield()
        
        let labelStackView  = createLabelStackView(with: slotCount)
        addSubview(labelStackView)
        
        addGestureRecognizer(tapRecognizer)
        
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: topAnchor),
            labelStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
		
    }
    
    private func configureTextfield() {
        tintColor = .clear
        textColor = .clear
        keyboardType = .numberPad
        textContentType = .oneTimeCode
        isSecureTextEntry = true
		text = nil
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        delegate = self
    }
    
    private func createLabelStackView(with count: Int) -> UIStackView {
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints =  false
        stackview.axis = .horizontal
        stackview.alignment = .fill
        stackview.distribution = .fillEqually
        stackview.spacing = 8
        
        for _ in 1 ... count {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 40)
            label.isUserInteractionEnabled = true
            label.text =  defaultCharacter
            stackview.addArrangedSubview(label)
            
            digitLabels.append(label)
        }
        
        return stackview
    }
    
    @objc
    private func textDidChange() {
        guard let text = self.text, text.count <= digitLabels.count else { return }
        
        for i in 0 ..< digitLabels.count {
            let currentLabel = digitLabels[i]
            if i < text.count {
                currentLabel.text = "*"
                
            } else {
                currentLabel.text = defaultCharacter
            }
        }
        
        if text.count == digitLabels.count {
            didEnterLastDigit?(text)
        }
    }

    func setErrorState(_ isError: Bool) {
            isErrorState = isError
            textDidChange()
        }

}

extension OneTimeCodeTextfield: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let characterCount = textField.text?.count else { return false }
        return characterCount < digitLabels.count || string == ""
    }
}
